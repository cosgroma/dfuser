# LVM Management

## Step 1: Find out information about existing LVM

LVM Storage Management divided into three parts:

* Physical Volumes (PV)
  * Actual disks
  * e.g. /dev/sda, /dev,sdb, /dev/sda and so on
* Volume Groups (VG)
  * Physical volumes are combined into volume groups.
  * e.g. my_vg = /dev/sda + /dev/sdb.
* Logical Volumes (LV)
  * A volume group is divided up into logical volumes
  * e.g. my_vg divided into my_vg/data, my_vg/backups, my_vg/home, my_vg/mysqldb and so on

Type the following commands to find out information about each part.

### How to display physical volumes (pv)

Type the following pvs command to see info about physical volumes:

```bash
sudo pvs
```

```text
PV             VG        Fmt  Attr PSize  PFree 
/dev/nvme0n1p3 ubuntu-vg lvm2 a--  <1.82t <1.72t
```

So currently my LVM include a physical volume (actual disk) called /dev/nvme0n1p3.

To see detailed attributes information, type:

```bash
sudo pvdisplay
```

```text
--- Physical volume ---
PV Name               /dev/nvme0n1p3
VG Name               ubuntu-vg
PV Size               <1.82 TiB / not usable 4.00 MiB
Allocatable           yes
PE Size               4.00 MiB
Total PE              476150
Free PE               450550
Allocated PE          25600
PV UUID               GVzKWR-fr5B-9rb7-hKc1-8hr6-SClH-d7KYB2
```

From above output it is clear that our volume group named `ubuntu-vg` is made of a physical volume named `/dev/nvme0n1p3`.

### How to display information about LVM volume Groups (vg)

Type any one of the following vgs command/vgdisplay command to see information about volume groups and its attributes:

```bash
sudo vgs
```

```text
VG        #PV #LV #SN Attr   VSize  VFree
ubuntu-vg   1   1   0 wz--n- <1.82t <1.72t
```

```bash
sudo vgdisplay
```

Sample outputs:

```text
--- Volume group ---
VG Name               ubuntu-vg
System ID
Format                lvm2
Metadata Areas        1
Metadata Sequence No  2
VG Access             read/write
VG Status             resizable
MAX LV                0
Cur LV                1
Open LV               1
Max PV                0
Cur PV                1
Act PV                1
VG Size               <1.82 TiB
PE Size               4.00 MiB
Total PE              476150
Alloc PE / Size       25600 / 100.00 GiB
Free  PE / Size       450550 / <1.72 TiB
VG UUID               0JwvmO-8OOA-nM8v-HIt8-n9Cf-CogI-6rbhWd
```

### How to display information about LVM logical volume (lv)

Type any one of the following lvs command/lvdisplay command to see information about volume groups and its attributes:

```bash
sudo lvs
```

OR

```bash
sudo lvdisplay
```

Sample outputs:


My ubuntu-vg volume group divided into two logical volumes:

/dev/ubuntu-vg/root – Root file system
/dev/ubuntu-vg/swap_1 – Swap space

Based upon above commands, you can get a basic idea how LVM organizes storage device into Physical Volumes (PV), Volume Groups (VG), and Logical Volumes (LV):


## Step 2: Find out information about new disk
You need to add a new disk to your server. In this example, for demo purpose I added a new disk drive, and it has 5GiB size. To find out information about new disks run:

```bash
sudo fdisk -l
```

OR

```bash
sudo fdisk -l | grep '^Disk /dev/'
```

Another option is to scan for all devices visible to LVM2:

```bash
sudo lvmdiskscan
```

Sample outputs:

```text

```

## Step 3: Create physical volumes (pv) on new disk named /dev/sda

Type the following command:

```bash
sudo pvcreate /dev/sda
```

Sample outputs:

Now run the following command to verify:

```bash
sudo lvmdiskscan -l
```

Sample outputs:
```text
  WARNING: only considering LVM devices
  /dev/nvme0n1p3                   [      39.52 GiB] LVM physical volume
  /dev/sda                    [       5.00 GiB] LVM physical volume
  1 LVM physical volume whole disk
  1 LVM physical volume
```

## Step 4: Add newly created pv named /dev/sda to an existing lv

Type the following command to add a physical volume /dev/sda to “ubuntu-vg” volume group:

```bash
sudo vgextend ubuntu-vg /dev/sda
```

/dev/mapper/ubuntu--vg-root
/dev/mapper/ubuntu--vg-home
/dev/mapper/ubuntu--vg-opt

Sample outputs:

```text
Volume group "ubuntu-vg" successfully extended
Finally, you need extend the /dev/ubuntu-vg/root to create total 45GB (/dev/sda (5G)+ existing /dev/
ubuntu-vg/root (40G))
```

```bash
sudo lvm lvextend -l +100%FREE /dev/ubuntu-vg/root
```


# Update Site

```bash
sudo cp nginx/sites-available/ai.sergeant.work.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/gitlab.sergeant.work.conf /etc/nginx/sites-enabled/gitlab.sergeant.work.conf
```