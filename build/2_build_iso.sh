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

echo "Starting ISO build."
sudo remastersys dist
echo "Copying the built ISO to your home folder."
sudo chmod 777 /home/remastersys/remastersys/custom.iso
cp /home/remastersys/remastersys/custom.iso ~/build.iso
echo "Cleaning up."
sudo rm -R /home/remastersys/
echo "Done. You can now burn your ISO and try your custom build of GenOS."
