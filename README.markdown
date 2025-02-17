ngx_upstream_jdomain
====================

An asynchronous domain name resolve module for nginx upstream

Installation:

	./configure --add-module=/path/to/this/directory
	make
	make install

Alternatively, you can use the module as a dynamic module. This allows you to use a maintained NGINX base image. Extract the module `.so` file from the docker build of this repository & place it into /etc/nginx/modules. Then load it using:

	load_module modules/ngx_http_upstream_jdomain_module.so;

Usage:

	upstream backend {
		hostname example.com;
		#hostname example.com port=8080 interval=5;
	}

	resolver 8.8.8.8; #Your Local DNS Server (use 127.0.0.11 for Docker)

directive `hostname`:

	* Syntax: hostname <domain-name> [port=80] [max_ips=20] [interval=1] [retry_off] [no_fail]
	* Context:    upstream
	* port:       Backend's listening port.
	* max_ips:    IP buffer size.
	* interval:   How many seconds to resolve domain name.
	* retry_off:  Do not retry if one IP fails.
	* no_fail:    Do not exit with error in case domain name resolution fails at startup.

See https://www.nginx.com/resources/wiki/modules/domain_resolve/ for details.

Author
======

wdaike <wdaike@163.com>, Baidu Inc.

Copyright & License
===================

This module is licenced under the BSD License.
Copyright (C) 2014-2014, by wdaike <wdaike@163.com>, Baidu Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

