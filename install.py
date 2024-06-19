#!/usr/bin/python3

import argparse
import configparser
import sys
from subprocess import Popen, PIPE
import logging
import platform

# Setup logger
sh = logging.StreamHandler(sys.stdout)
sh.setFormatter(logging.Formatter('%(asctime)-15s %(levelname)s: %(message)s'))
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logger.addHandler(sh)


linux_flavor_name = platform.freedesktop_os_release().get('ID', None)
linux_flavor_version = platform.freedesktop_os_release().get('VERSION_ID', None)

UBUNTU_NAME = 'ubuntu'
FEDORA_NAME = 'fedora'
supported_linux_flavors = {
    UBUNTU_NAME : {
        '20.04' : True,
        '22.04' : True,
    },
    FEDORA_NAME : {
        '35' : True,
    },
}


def fatal(msg):
    logger.critical(msg)
    sys.exit(-1)


def os_is_ubuntu():
    return linux_flavor_name == UBUNTU_NAME


def os_is_fedora():
    return linux_flavor_name == FEDORA_NAME


def check_os():
    if linux_flavor_name is None:
        fatal("Could not find OS name")
    if linux_flavor_version is None:
        fatal("Could not find OS version")

    supported_versions = supported_linux_flavors.get(linux_flavor_name)
    supported = supported_versions.get(linux_flavor_version, False)
    if not supported:
        fatal(f"Current OS ({linux_flavor_name} {linux_flavor_version}) is not supported")


def exec(cmd):
    logger.info(f"Run command: '{cmd}'")
    # universal_newlines=True - means open in text mode
    # bufsize=0 - means unbuffered (read and write are one system call and can return short)
    sh = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE, universal_newlines=True, bufsize=0)
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
        fatal("The command finished with error code: %d" % code)


def pkg_manager_update():
    if os_is_ubuntu():
        exec("sudo apt-get update")
    elif os_is_fedora():
        exec("sudo dnf update -y")
    else:
        fatal("Unknown OS")


def pkg_manager_install(pkgs):
    logger.info(f"Install following packages: {pkgs}")
    if os_is_ubuntu():
        exec(f"sudo DEBIAN_FRONTEND=noninteractive apt-get install -y {pkgs}")
    elif os_is_fedora():
        exec(f"sudo dnf install -y {pkgs}")
    else:
        fatal("Unknown OS")


def multiline_apply(multilined_data_str, handler):
    data_list = multilined_data_str.split('\n')
    for data in data_list:
        handler(data)


def packages_handler(section, value):
    logger.debug(f"Run packages_handler for {section}")
    if value is None:
        logger.debug("No 'packages' value is provided")
        return
    # make one line value
    values = value.split('\n')
    pkg_manager_install(" ".join(values))


def sh_handler(section, value):
    logger.debug(f"Run sh_handler for {section}")
    if value is None:
        logger.debug("No 'sh' value is provided")
        return
    filename = f"{section}-section.sh"
    with open(filename, "w") as f:
        f.write(value)
    exec(f"/bin/bash {filename}")


if __name__ == "__main__":
    check_os()

    parser = argparse.ArgumentParser(description='Linux Custom Configurations')
    parser.add_argument('-s','--section', help='The section to setup.')
    parser.add_argument('-d','--dry-run', help='Print info about section but do not setup it.', action=argparse.BooleanOptionalAction)
    args = vars(parser.parse_args())

    config = configparser.ConfigParser()
    config.read('config.ini')
    sections = config.sections()

    arg_section = args.get('section', None)
    arg_dry_run = args.get('dry_run', False)

    if arg_section:
        try:
            config[arg_section]
        except KeyError:
            logger.error(f"'{arg_section}' section does not exist")
            sys.exit(1)

    # dump section and section
    logger.debug("##################################################################")
    for section in sections:
        if arg_section and arg_section != section:
            continue
        logger.debug(f"Section: {section}")
        for key in config[section]:
            logger.debug("    %s = '%s'" % (key, config[section][key]))
    logger.debug("##################################################################")
    
    if arg_dry_run:
        sys.exit(0)

    # define variables with common keys
    key_packages = 'packages'
    key_sh = 'sh'

    # update all packages before any actions
    pkg_manager_update()

    for section in sections:
        if arg_section and arg_section != section:
            continue
        sh_handler(section, config[section].get(key_sh, None))
        packages_handler(section, config[section].get(key_packages, None))
