# shakkikello
GitHub for Fast chess


The whole software is licensed under GPLv3. Single files may be further developed under BSD also. See the actual file start for details.

Release process

There will be master branch which is a code for the releases in Jolla Harbour, OpenRepos.net and Mer OBS. The phases for the release are:

1. The new version will be devoloped in dev(version) branch
2. When translations are not changing any more the new translation file will be downloaded to www.transifex.com
3. When translations are ready check their visualization
4. Remove extra console.logs from the code
5. Finalize harbour-shakkikello.changes file
6. Test the app
7. Do Jolla Harbour tests for the rpms (https://forum.sailfishos.org/t/missing-harbour-validator/2583/3):
    alias sfdk=~/SailfishOS/bin/sfdk
    sfdk config target=SailfishOS-5.0.0.62-aarch64
    sfdk check harbour-shakkikello-0.9.2-1.aarch64.rpm
    alias sfdk=~/SailfishOS/bin/sfdk
    sfdk config target=SailfishOS-5.0.0.62-armv7hl
    sfdk check harbour-shakkikello-0.9.2-1.armv7hl.rpm
    alias sfdk=~/SailfishOS/bin/sfdk
    sfdk config target=SailfishOS-5.0.0.62-i486
    sfdk check harbour-shakkikello-0.9.2-1.i486.rpm
8. Commit changes for the version, amend commits if changes are needed in the test process
9. Merge dev branch to the master 
    git checkout master
    git merge dev092
10. Move the source to GitHub
    git push origin master
11. Create package from GitHub master to the https://build.sailfishos.org 
    tar -czvf harbour-shakkikello-0.9.2.tar.bz2 harbour-shakkikello-0.9.2
12. Load bz2 file and spec file to chum:testing
13. Test package with different devices
14. Submit package to chum
15. Load the local rpms to Jolla Harbour and edit release info
16. Load the local rpms to OpenRepos and edit release info

