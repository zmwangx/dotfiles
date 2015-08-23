#!/usr/bin/python

import argparse
import json
import os
import re
import subprocess

def brew_formula_installed(optstring):
    """Check if a formula is installed with the expected options.

    Parameters
    ----------
    optstring : str
        A string that usually follows ``brew install``, with the formula
        name (possibly with a tap prefix) followed by installation
        options.

    Returns
    -------
    bool

    """
    tokens = re.split(r"\s+", optstring)
    formula_name = tokens[0]
    formula_expected_options = set(tokens[1:])

    try:
        formula_keg = subprocess.check_output(["brew", "--prefix", formula_name],
                                              stderr=subprocess.PIPE).strip()
    except subprocess.CalledProcessError:
        return False

    if not os.path.exists(formula_keg):
        return False

    formula_receipt = os.path.join(formula_keg, "INSTALL_RECEIPT.json")
    if not os.path.exists(formula_receipt):
        return False

    try:
        with open(formula_receipt) as fp:
            formula_metadata = json.load(fp)
            formula_installed_options = set(formula_metadata["used_options"])
    except Exception:
        return False

    return formula_expected_options == formula_installed_options

def main():
    """CLI interface."""
    parser = argparse.ArgumentParser()
    parser.add_argument("optstring")
    args = parser.parse_args()
    exit(0 if brew_formula_installed(args.optstring) else 1)

if __name__ == "__main__":
    main()
