#! /usr/bin/env -S python3 -B


from pelican import DEFAULT_CONFIG_NAME, parse_arguments
from pelican.settings import get_settings_from_file
from os.path import abspath, isfile
from shlex import quote


def get_settings(argv):
    args = parse_arguments(argv)
    conf = args.settings

    if conf is None and isfile(DEFAULT_CONFIG_NAME):
        conf = args.settings = DEFAULT_CONFIG_NAME

    settings = get_settings_from_file(conf)
    settings['SETTINGS'] = conf

    override = (
        ('path', 'PATH'),
        ('output', 'OUTPUT_PATH'),
        ('theme', 'THEME'),
    )

    # this is basically pelican.get_config but without the path expansion
    for attr, key in override:
        val = getattr(args, attr, None)
        if val:
            settings[key] = val

    return settings


def main(argv):
    settings = get_settings(argv)

    wanted = (
        'SETTINGS', 'PATH', 'OUTPUT_PATH',
        'THEME', 'SITEURL', 'SITENAME', 'SITESUBTITLE',
    )

    for key in wanted:
        print(f'{key.lower()}={quote(settings.get(key))}')


if __name__ == '__main__':
    import sys
    main(sys.argv[1:])


# The end.
