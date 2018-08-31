#!/usr/bin/python3

import configparser
import os
import sys
from subprocess import Popen, PIPE
import logging
import re

# Setup logger
sh = logging.StreamHandler(sys.stdout)
sh.setFormatter(logging.Formatter('%(asctime)-15s %(levelname)s: %(message)s'))
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logger.addHandler(sh)


def die(msg):
    logger.critical(msg)
    sys.exit(-1)


def file_read(filename):
    r""" Reads file and returns content """
    content = None
    with open(filename, 'r') as file_obj:
        content = file_obj.read()
    return content


def file_write(filename, content):
    r""" Writes content to file"""
    with open(filename, 'w') as file_obj:
        file_obj.write(content)


def exec(cmd):
    # universal_newlines=True - means open in text mode
    # bufsize=0 - means unbuffered (read and write are one system call and can return short)
    sh = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE, universal_newlines=True, bufsize=0)
    logger.info("Run command: %s", cmd)
    # But do not wait till the command finish, start displaying output immediately
    stdout_lines_iterator = iter(sh.stdout.readline, "")
    stderr_lines_iterator = iter(sh.stderr.readline, "")
    while sh.poll() is None:
        for line in stdout_lines_iterator:
            nline = line.rstrip()
            logger.info(nline)

        for line in stderr_lines_iterator:
            nline = line.rstrip()
            logger.error(nline)
    
    code = int(sh.returncode)
    if code != 0:
        die("The command finished with error code: %d" % code)


def apt_update():
    exec("sudo apt update")


def apt_install(pkgs):
    logger.info("Install following packages: %s" % pkgs)
    exec("sudo apt install -y %s" % pkgs)


def multiline_apply(multilined_data_str, handler):
    data_list = multilined_data_str.split('\n')
    for data in data_list:
        handler(data)


def file_copy_with_update(src_file, dest_file, values):
    src_content = file_read(os.path.expanduser(src_file))
    if src_content is None:
        die("File '%s' not found" % src_file)

    try:
        dst_content = src_content.format(**values)
    except KeyError as key_error:
        die("Value for '%s' was not provided" % str(key_error))
    file_write(os.path.expanduser(dest_file), dst_content)


def packages_handler(section, value):
    logger.debug("Run packages_handler for %s" % section)
    if value is None:
        logger.debug("No 'packages' value is provided")
        return
    # make one line value
    values = value.split('\n')
    apt_install("".join(values))


def sh_handler(section, value):
    logger.debug("Run sh_handler for %s" % section)
    if value is None:
        logger.debug("No 'sh' value is provided")
        return
    multiline_apply(value, exec)


def copy_and_edit_handler(section, value, all_group_variables):
    logger.debug("Run copy_and_edit_handler for %s" % section)
    if value is None:
        logger.debug("No 'copy_and_edit' value is provided")
        return

    prog = re.compile(r"(?P<src>.*)\s+to\s+(?P<dest>.*)")

    def parse_value(single_value):
        result = prog.match(single_value)
        if result is None:
            die("Invalid value '%s'", single_value)
        else:
            file_copy_with_update(result.group('src'), result.group('dest'), all_group_variables)

    multiline_apply(value, parse_value)



if __name__ == "__main__":
    config = configparser.ConfigParser()
    config.read('config.ini')
    sections = config.sections()

    # dump all section
    logger.debug("##################################################################")
    for section in sections:
        logger.debug("section: %s" % section)
        for key in config[section]:
            logger.debug("    %s = '%s'" % (key, config[section][key]))
    logger.debug("##################################################################")

    # define variables with common keys
    key_packages = 'packages'
    key_sh = 'sh'
    key_cope_and_edit = 'copy_and_edit'

    # update all packages before any actions
    apt_update()

    for section in sections:
        copy_and_edit_handler(section, config[section].get(key_cope_and_edit, None), config[section])
        sh_handler(section, config[section].get(key_sh, None))
        packages_handler(section, config[section].get(key_packages, None))
