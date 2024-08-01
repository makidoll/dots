# Extras for Audio

Everything here has been tested with PipeWire

## Virtual Audio Cable

After installing the service file, create virtual audio cables using:

`systemctl enable --user --now virtual-cable@OBS`<br>
(OBS as example for monitoring)

`vim ~/.config/systemd/user/virtual-cable@.service`

```service
[Unit]
Description=%i Virtual Cable
After=pipewire-pulse.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/pactl load-module module-null-sink \
sink_name=%i \
sink_properties="'device.description=\"%i Virtual Cable\"'"
ExecStart=/usr/bin/pactl load-module module-remap-source \
source_name=%i master=%i.monitor \
source_properties="'device.description=\"%i Virtual Cable\"'"
ExecStop=bash -c "/usr/bin/pactl unload-module \
$(pactl list short modules | grep sink_name=%i | cut -d$'\t' -f1)"
ExecStop=bash -c "/usr/bin/pactl unload-module \
$(pactl list short modules | grep source_name=%i | cut -d$'\t' -f1)"

[Install]
WantedBy=default.target
```
