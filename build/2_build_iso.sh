echo "Starting ISO build."
sudo remastersys dist
echo "Copying the built ISO to your home folder."
sudo chmod 777 /home/remastersys/remastersys/custom.iso
cp /home/remastersys/remastersys/custom.iso ~/build.iso
echo "Cleaning up."
sudo rm -R /home/remastersys/
echo "Done. You can now burn your ISO and try your custom build of GenOS."
