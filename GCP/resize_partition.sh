*   **Identify your partition:** Use `lsblk` to determine the name of your boot partition (e.g., `/dev/sda1`).
*   **Resize the partition:** Use `growpart /dev/sda1`.  Replace `/dev/sda1` with the correct partition name.
*   **Resize the filesystem:** Use `resize2fs /dev/sda1`. Again, replace `/dev/sda1` with the correct partition name. This command only works for ext2, ext3, and ext4 filesystems.  For other filesystems (like btrfs or xfs), use the appropriate command for that filesystem type.
