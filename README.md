# DNS@Home

DNS@Home is my preferred style of DNS and DHCP servers. I found Bind and ICS DHCP a pain to setup and manage myself over a longer period of time so I've elected to create something I want to use for my own purposes.

## DNS Server Features

The DNS server will support A, AAAA, CNAME, MX, PTR, SOA, SRV, and TXT resource records. If you'd like to add one feel free to submit a pull request!

In addition to DNS records, the DNS server will also support dynamic DNS updates on it's own, although the most effective way to accomplish this will be to use the included DHCP server that integrates into the DNS server.

The DNS server will support features like: recursive lookups, UTF8 records (yes, really), old record scavenging, conditional forwarding, zone transfers, primary zones, secondary zones, and stub zones.

At this time there is no plan to implement DNSSEC, if anything, DNS over HTTPS would be used instead.

## DHCP Server Features

The DHCP server will support dynamic updates to the DNS server, reservations, lease scopes, scope and server level DHCP options, MAC address filtering, DHCPv4, and DHCPv6.

## Non-goals

I'm not looking to replace BIND and ICS DHCP, I find them too heavy for my purposes so I'm creating something that fits my needs and hopefully yours too!

An non-Affero type license. Sorry, but if you want to extend this code base you're going to have to contribute those extensions back! It helps me out!
