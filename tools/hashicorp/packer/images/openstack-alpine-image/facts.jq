
# set the qemu accelerator value
  if .osfamily == "Darwin" then . + { "qemu_accelerator": "hvf"  }
elif .osfamily == "Linux"  then . + { "qemu_accelerator": "kvm"  }
else                            . + { "qemu_accelerator": "none" }
 end
# inject the arg values
| . + { "project_directory": $project_directory, "image_name_base": $image_name_base }
