+++
date = "2014-02-03T23:18:53-07:00"
title = "Introducing Battleschool"
categories = [
  "battleschool"
]
+++

I've been on an [Ansible](http://ansible.com) kick recently at work ([domo](http://domo.com)). While working on a
project, I started creating a simple workstation setup playbook.  I got to thinking that someone must have done this
already.  I remembered [boxen](http://boxen.github.com) by github.

What follows is my journey to the creation of a tool called [battleschool](https://github.com/spencergibb/battleschool).

<!--more-->

A few things that aren't necessarily bad about boxen, but rub me the wrong way: 1) Puppet, 2) installation.

Every time I have tried a [puppet](http://puppetlabs.com/puppet/what-is-puppet) tutorial (or chef, more on that later),
I've never found them simple or easy to follow.  When I found ansible, its first goal is to be simple, simple to
install, configure, execute (it's only requirement on the machine it's going to provision is ssh and python). Ansible's
syntax is yaml, as simple a markup language as I've seen.  You can write modules in any language you want, but library
of modules is written in python.

The installation of boxen seems awkward to me.  I was looking for a simple install and then point to a company setup,
rather than customize a boxen fork.

I searched for an alternative to boxen and came upon [kitchenplan](https://github.com/kitchenplan/kitchenplan). It's
similar to boxen, but based on [chef](http://docs.opscode.com).  I have had similar issues with chef as I've had with
puppet.  Kitchenplan still involves forking, but is a little more sane.

So, I did what a good developer does and created my own: [battleschool](https://github.com/spencergibb/battleschool).  It
uses the ansible API to setup, configure and run ansible playbooks.  It's still got some rough edges, so bear with me.
I use it regularly.  In fact, since I started writing this post, I had to wipe my machine because of some bad
partitions I created.  When I tried to install [OS X Mavericks](http://en.wikipedia.org/wiki/OS_X_Mavericks), I ended up
having to delete the partitions and start over. I was back up and running in 2 hours and most of that time was
downloading packages to install.

In short, battleschool downloads and executes ansible playbooks against your local machine in a manner that is simple to
configure and repeatable in cases of disaster (bad) or new machines (good).

### Simple Install

I wanted a no forking install for battleschool.

    #if needed
    $ sudo easy_install pip

    $ sudo pip install battleschool

That's it.  Battleschool depends on ansible, so that will be installed via pip as well.  I haven't done any work to
deal with alternative installs of ansible via [homebrew](http://brew.sh), [macports](http://www.macports.org) or
[apt](http://en.wikipedia.org/wiki/Advanced_Packaging_Tool) (yes, this will work on linux/bsd as well).

### Private Playbook Repos

Battleschool uses the [git](http://docs.ansible.com/git_module.html) and
[get_url](http://docs.ansible.com/get_url_module.html) ansible modules to download remote playbooks.  That means you can
use private, self-hosted git repositories, private or public [github](http://github.com) or
[bitbucket](https://bitbucket.org) repositories, or dropbox to host your playbooks!  Extreme flexibility without
forking battleschool.  Other version control systems (VCS) such as svn or mercurial should be simple to add because of
ansible's support for them.

### Built On Ansible

I use ansible's python api, so most of ansible-playbooks options are available to battleschool.  All of ansible's
[modules](http://docs.ansible.com/modules_by_category.html) are available.  I have been using ansible 1.3 to develop
and plan on upgrading to 1.4 shortly.  Ansible, IMHO, is the most straightforward provisioner I have tried.  It's
written in python, which I have enjoyed.

## TL;DR

Some of this comes from the [README.md](https://github.com/spencergibb/battleschool/blob/master/README.md)

### About the Name

I learned about the term [ansible](http://en.wikipedia.org/wiki/Ansible#In_Card.27s_work) from Ender's Game. Taking a
cue from Kitchenplan, I wanted to name my project with something from the enderverse.  I settled on battleschool as the
project name and battle as the command.

### Running battleschool

    battle --ask-sudo-pass     #if you have setup nopasswd in sudo then omit --ask-sudo-pass

I alias `battle` to `battle --ask-sudo-pass`.  This will fail with a
`file not found: /Users/username/.battleschool/config.yml` (A better error would be nice :-).  You need to create a
config file first.  I plan on creating a default one if battleschool doesn't find one.  If you are following along:

    mkdir ~/.battleschool
    cd .battleschool
    curl -L https://db.tt/aG2uyydU > config.yml    #this downloads my config as a starting point

### config.yml

    ---
    sources:
      local:
        #- playbook.yml

      url:
        #- name: playbook.yml
        #  url: https://db.tt/VcyI9dvr

      git:
        - name: 'osx'
          repo: 'https://github.com/spencergibb/ansible-osx'
          playbooks:
             #- adium.yml

#### explanation of ~/.battleschool/config.yml

##### local sources

    sources:
      local:
        - playbook.yml

Any [ansible playbooks](http://docs.ansible.com/playbooks.html) located in ~/battleschool/playbooks
can be listed under local.  Each playbook will be executed in order.  This can useful for custom
configuration per workstation.  (You could install apps with homebrew or macports if those are installed, for example).
After adding url sources (see below), this should probably be used sparingly.

##### url sources

   url:
     - name: playbook.yml
       url: https://db.tt/VcyI9dvr

Playbooks located at a url.  Each playbook will be executed in order.  Helpful for bootstrapping (ie, the first time
you run battleschool).  For example, if you are restoring a machine, you might run:

    battle --config-file=https://db.tt/aG2uyydU

or more realistically

    sudo pip install battleschool && battle --ask-sudo-pass --config-file=https://db.tt/aG2uyydU

As long as there are no local sources, everything will be downloaded and run.

*NOTE: playbooks under the `local` or `url` sections, cannot reference anything outside of their own contents (e.g.
files, templates, roles, etc...).  See git sources below for more advanced playbooks.*

##### git sources

    git:
      - name: 'osx'
        repo: 'https://github.com/spencergibb/ansible-osx'
        playbooks:
           - adium.yml

Any git repo that hosts ansible playbooks (specific to battleschool or not) will work here.  Each item under
playsbooks is the relative location to a playbook in the specified git repository.  In the example above, adium.yml
is in the root of the ansible-osx repository.

##### git repo sources

Directory Layout

The top level of the directory would contain files and directories like so:

    local.yml                 # optional master playbook, automatically run, no need to list under playbooks

    dev.yml                   # example playbook for dev
    ux.yml                    # example playbook for ux
    chrome.yml                # example playbook for the chrome browser
    dir/myapp.yml             # example playbook, supports nesting one level deep

    roles/                    # optional standard ansible role hierarchy
    library/                  # optional remote module definitions

See the [roles docs](http://docs.ansible.com/playbooks_roles.html#roles) for information about ansible roles and their
directory layout. The `library` directory is the location for placing
[custom ansible modules](http://docs.ansible.com/developing_modules.html).


#### the mac_pkg module

This is the meat of battleschool.  How do you install mac apps?

If you look most of the playbooks in [this git repo](https://github.com/spencergibb/ansible-osx) you will see the use of
the mac_pkg module.  Mac apps are usually a pkg (or mpgk) installer, or the bare .app directory.  They can be archived
in a number of formats: DMG or zip commonly.  Pkg files may not be archived at all.  Less common formats (tar or 7zip)
are not supported yet.

Lets look at adium.yml

    ---
    - hosts: workstation

      tasks:
        - name: install Adium
          mac_pkg: pkg_type=app
                   url=http://sourceforge.net/projects/adium/files/Adium_1.5.7.dmg/download
                   archive_type=dmg archive_path=Adium.app
          sudo: yes

`- hosts: workstation` this is required in each playbook as it targets the local workstation.  Though this is generally
arbitrary for most ansible users, it must be `workstation` in battleschool.

`pkg_type=app` type must be pkg, app or script.  Defaults to pkg.
[This](https://raw.github.com/spencergibb/ansible-osx/master/homebrew.yml) is an example of a `script` pkg_type.

`url=....` the url of the app to download, alternatively a local src path, such as `src=/local/path/to/app.dmg`, may be
used instead.

`archive_type=dmg` one of dmg, zip or none.  Defaults to none.

`archive_path=Adium.app` The path to the app or pkg in the archive.

`sudo: yes` required for mac_pkg tasks (this will prompt you to enter you sudo password only once)

From java7.yml

    ---
    - hosts: workstation

      tasks:
        - name: install java 7 update 25
          mac_pkg: pkg_name=com.oracle.jdk7u25 pkg_version=1.1
                   url=https://edelivery.oracle.com/otn-pub/java/jdk/7u25-b15/jdk-7u25-macosx-x64.dmg
                   curl_opts='--cookie gpw_e24=http%3A%2F%2Fwww.oracle.com'
                   archive_type=dmg archive_path='JDK 7 Update 25.pkg'
          sudo: yes

`pkg_name=com.oracle.jdk7u25` the name of the pkg found by `pkgutil --packages`

`pkg_version=1.1` the version of the package as reported by `pkgutil --pkg-info com.oracle.jdk7u25`

`curl_opts=...` cookie needed to download java from oracle, supports all curl options

*NOTE: battleschool, currently does not install apps from the Apple App Store.*


### Homebrew

So, you like [homebrew](http://brew.sh) and want to use it to install apps on you mac.  No problem.  Battleschool can
install homebrew for you ([see this playbook](https://raw.github.com/spencergibb/ansible-osx/master/homebrew.yml)).
Already have homebrew installed? No, problem, it won't try and install it again.

## Where to start?

Probably the easiest way to start is by looking at my configuration:

Config file: https://db.tt/aG2uyydU

My url playbook: https://db.tt/VcyI9dvr

My playbook git repo: https://github.com/spencergibb/ansible-osx

### How to contact me or the community?

Google group: https://groups.google.com/d/forum/battle-school

Github project for issues, forks, pull requests: https://github.com/spencergibb/battleschool
