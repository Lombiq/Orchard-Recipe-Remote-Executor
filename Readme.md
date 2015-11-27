# Orchard External Pages Readme



## Project Description

Orchard module for aggregating pages from external sources


## Features

- Can aggregate Markdown pages and corresponding files from a Bitbucket repository
- Options to set up mappings between local urls and repository paths as well as specifying the maximal size of files to be mirrored (if mirroring at all)


## Documentation

**The module depends on [Helpful Libraries](https://gallery.orchardproject.net/List/Modules/Orchard.Module.Piedone.HelpfulLibraries) (at least 1.8) . Please install it prior to installing the module!**

This module's aim is to provide a tool for aggregating contents from external sources. The module currently can fetch Markdown (.md) files from a Bitbucket repository and save their content as content items.

The initial version of External Pages was demoed on the [Orchard Community Meeting](http://youtu.be/iwXWpkr_rdk?t=47m55s).

### Usage

After installation you'll see a new "External Pages" menu item under Settings. Configure repository access there. For public repos you can leave the username/password blank.

After setting up a repository access you have to click the "Repopulate" button before the content will be auto-updated (this is so you can defer the initial population). After clicking the button the repository's content will be pulled in from the current state.

After the initial population a background task will check for new changesets every configurable amount of minutes (only from the default branch so you can use branches to distinguish between what should appear on the site) and process changesets in order, one per minute. The processing is **differential**, meaning that modified markdown pages will be changed, added ones created and removed ones also removed from Orchard. The same stands for mirrored files.

When you click "Repopulate" any time the current state of the repository will be pulled in, overtaking changeset processing. This means that if there are changesets in the queue and you repopulate content from the repository those changeset jobs will never be processed. Instead, the current state of the repository will be mirrored, in an **incremental** way. E.g. if there was a file deleted in a changeset and you repopulate before that changeset can be processed the file won't be removed locally.

Markdown (.md) files are converted to content items.

- Index.md files are treated as directory indices just as it's standard with webservers. If you open a directory that has an index file the pattern "directory/" (note the trailing slash!) will work.
- Other files are put under urls the same as their file name and can be access with the "filename" or if they're in a directory then "directory/filename" pattern (note that for files there's no trailing slash!).

E.g. if there's an Index.md and Other.md in the folder Directory, that "Directory/" path will lead to Index.md and "Directory/Other" to Other.md.

### See the [Version history](Docs/VersionHistory.md)

External Pages drives the [Orchard Dojo Library](http://orcharddojo.net/orchard-resources/Library/) and the [DotNest Knowledge Base](http://dotnest.com/knowledge-base/).

You can install External Pages from the [Orchard Gallery](https://gallery.orchardproject.net/List/Modules/Orchard.Module.OrchardHUN.ExternalPages).

The module's source is available in two public source repositories, automatically mirrored in both directions with [Git-hg Mirror](https://githgmirror.com):

- [https://bitbucket.org/Lombiq/orchard-external-pages](https://bitbucket.org/Lombiq/orchard-external-pages) (Mercurial repository)
- [https://github.com/Lombiq/Orchard-External-Pages](https://github.com/Lombiq/Orchard-External-Pages) (Git repository)

Bug reports, feature requests and comments are warmly welcome, **please do so via GitHub**.
Feel free to send pull requests too, no matter which source repository you choose for this purpose.

This project is developed by [Lombiq Technologies Ltd](http://lombiq.com/). Commercial-grade support is available through Lombiq.