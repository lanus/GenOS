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
