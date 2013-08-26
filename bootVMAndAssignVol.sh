#!/bin/bash

#=========================================================
#author: René Muhl
#from: Leipzig, Germany
#last change: 26.8.2013
#email: ReneM{dot}github{at}gmail{dot}com
#=========================================================

#VM parameters
imageID="ab1d5094-5533-453d-b557-b4ed3e58aee9"
flavorID="8"
cloudInitConfigFile="/home/controller/cloudinit/combined-userdata.txt"
VMname="disk-test"
additional="--availability-zone nova:nigeria"

#volume parameters
volumeType="lvm2"
volumeName="vol1"
volSize="10"
devPath="/dev/vdb"  #in VM


#boot new VM 
nova boot --image $imageID --flavor $flavorID --user-data $cloudInitConfigFile $VMname $additional

#create new cinder volume
cinder create --volume_type $volumeType --display_name $volumeName $volSize

#get cinder volume id
volID=`cinder list |  awk -F '|' '{print $2}' | grep -E '[0-9a-z]{8}(-[0-9a-z:]{4}){3}-[0-9a-z:]{12}'`

#waiting 10 seconds until the instance building_state != building, after that you can attach a volume
sleep 10

#combine VM with volume by attaching volume to VM with VM name and volume id
nova volume-attach $VMname $volID $devPath
