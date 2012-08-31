#!/bin/bash
cat >/etc/apt/apt.conf.d/50proxy <<!
Acquire::http::Proxy "http://33.33.33.1:3142";
Acquire::http::Proxy::archive.scrapinghub.com DIRECT;
!
