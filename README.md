# DNS Tray

Blocks ads, trackers and malware on your whole Windows PC. One tray icon controls it.

Mullvad shut down its public DNS in November 2026. On its last day I tested its servers to see which block lists they really used, and rebuilt that here. Quad9 does the lookups.

## Install

Open PowerShell, paste this, and click Yes when Windows asks:

```powershell
irm https://raw.githubusercontent.com/mattebin/dns-tray/main/install.ps1 | iex
```

## Use

Left click the icon to turn it on or off. Right click for the rest. If you do not see it, click the ^ arrow next to the clock and drag it out.

| Icon | Meaning |
|---|---|
| Green | All lists. Blocks the most, and is the most likely to break something. |
| Blue | Same as Mullvad. Matched 98% of its answers in my test. |
| Grey | Off. Your normal DNS. |
| Orange | Something failed. Your normal DNS is used until it works again. |

Adult, gambling and social media blocking are off. Turn them on under "Also block".

If a site breaks, switch to blue, or click "See what was blocked" and unblock it there.

## Good to know

- It installs [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) in `C:\Program Files\DNS Tray`. The download is checked against AdGuard's checksum and signature.
- Lists update every 12 hours. AdGuard Home updates itself.
- The "See what was blocked" page has no password, but only your PC can open it. It keeps 24 hours of history.
- Chrome, Edge and Brave may say they are managed by an organization while it is on. That is the setting that sends them through the filter.
- Firefox and other apps with their own secure DNS can skip the filter.
- Local names like `printer.lan` may stop working while it is on.

## Remove

Right click the icon and choose Uninstall. Your normal DNS comes back.

## Credits

Lists: [oisd](https://oisd.nl), [Frellwits](https://github.com/lassekongo83/Frellwits-filter-lists), [Firebog](https://firebog.net), [AdGuard](https://github.com/AdguardTeam/AdguardFilters), [Hagezi](https://github.com/hagezi/dns-blocklists), [Mullvad](https://github.com/mullvad/dns-blocklists).

Not made by or connected to Mullvad, Quad9 or AdGuard.
