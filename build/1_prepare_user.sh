# Copyright (C) 2011 Ivo Nunes
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

echo "Preparing the default user"
sudo rm -R /etc/skel/.kde
sudo rm -R /etc/skel/.config
sudo rm -R /root/.config
sudo rm -R /root/.kde
cd ~
sudo cp -R .kde /etc/skel/.kde
sudo cp -R .config /etc/skel/.config
sudo cp -R .kde /root/.kde
sudo cp -R .config /root/.config
cd /etc/skel/
sudo chown root:root .kde
sudo chown root:root .config
sudo chown -R root:root .kde
sudo chown -R root:root .config
sudo mkdir Documents
sudo mkdir Downloads
sudo mkdir Music
sudo mkdir Pictures
sudo mkdir Public
sudo mkdir Templates
sudo mkdir Videos
sudo chown root:root Documents
sudo chown root:root Downloads
sudo chown root:root Music
sudo chown root:root Pictures
sudo chown root:root Public
sudo chown root:root Templates
sudo chown root:root Videos
cd .kde
sudo rm -R cache* socket* tmp*
cd share/apps
sudo rm -R amarok kate kconf_update RecentDocuments klipper konsole nepomuk kfileplaces
cd ../config
sudo rm amarokrc arkrc k3brc katerc ksmserverrc startupconfigfiles klipperrc
sudo rm -R session
cd /etc/skel/.config/
sudo rm -R akonadi
cd /root/
sudo chown root:root .kde
sudo chown root:root .config
sudo chown -R root:root .kde
sudo chown -R root:root .config
cd .kde
sudo rm -R cache* socket* tmp*
cd share/apps
sudo rm -R amarok kate kconf_update RecentDocuments klipper konsole nepomuk kfileplaces
cd ../config
sudo rm amarokrc arkrc k3brc katerc ksmserverrc startupconfigfiles klipperrc
sudo rm -R session
cd /root/.config/
sudo rm -R akonadi
echo "Done."
