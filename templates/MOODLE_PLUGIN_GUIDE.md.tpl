# Moodle Plugin Development Guide

Moodle Version: {{MOODLE_VERSION}}

## Plugin Structure

Typical plugin structure:

plugin/
├── db/
│   ├── install.xml
│   ├── access.php
│   └── events.php
├── classes/
├── lang/
├── lib.php
├── version.php
└── settings.php

## Required Files

- version.php
- db/install.xml
- lang/en/pluginname.php

## Naming

Component format:

type_name

Example:

local_uvvtools
mod_quiz
block_navigation
