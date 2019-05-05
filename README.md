# wow-vanilla-addons
My collection of vanilla addons for World of Warcraft patch 1.12.

# Installation
Note that this repository makes heavy use of git submodules. As such, you must include the `--recurse-submodules` flag with your `git clone` operation, or by using `git submodule update` after a `git checkout` operation.

To install the files, place the contents of this repository **directly into** your AddOns folder and everything should appear just fine.
You may not be able to clone into a non-empty directory (which will be the case with the default AddOns folder), so either clone to a new directory then copy the contents over into your AddOns folder, or use the following snippet from within your AddOns folder:

```sh
cd <AddOns_directory_location>
git init .
git remote add -t \* -f origin https://github.com/deadmeu/wow-vanilla-addons.git
git checkout master
git submodule init
git submodule update
```
