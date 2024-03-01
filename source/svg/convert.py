#! /usr/bin/env python3


import sys

from argparse import ArgumentParser
from json import dump
from pkg_resources import resource_listdir, resource_string
from urllib.parse import quote


def load_one(name):
    if name.endswith(".svg"):
        fname = name
        name = fname[:-4]  # strip .svg
    else:
        fname = f"{name}.svg"

    return name, resource_string(__name__, fname).decode()


def load(names):
    return dict(map(load_one, names))


def load_all():
    return load(filter(lambda s: s.endswith(".svg"),
                       resource_listdir(__name__, "./")))


def css_url_encode(svg, mimetype="image/svg+xml"):
    return f'url("data:{mimetype};utf8,{quote(svg)}")'


def cli(options):

    loaded = load(options.names) if options.names else load_all()

    if options.json:
        dump(loaded, sys.stdout)
        print()
        return 0

    print(":root {")
    for name, svg in sorted(loaded.items()):
        print(f"  --svg-{name}: {css_url_encode(svg)};")
    print("}")


def create_argparser(progn):
    parser = ArgumentParser(progn)

    parser.add_argument("names", nargs="*",
                        help="specific social SVG names. If unspecified,"
                        " use all SVG files")

    parser.add_argument("--json", action="store_true",
                        help="display the map of social names to their"
                        " SVG string as JSON")

    return parser


def main(argv):
    progn, *args = argv
    parser = create_argparser(progn)
    options = parser.parse_args(args)

    try:
        return cli(options) or 0

    except OSError as ose:
        print(f"{ose.strerror}: {ose.filename}", file=sys.stderr)
        return 1

    except KeyboardInterrupt:
        print(file=sys.stderr)
        return 130


if __name__ == "__main__":
    sys.exit(main(sys.argv))


# The end.
