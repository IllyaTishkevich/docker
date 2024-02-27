#!/usr/bin/env bash
docker-compose exec varnish varnishadm "ban req.url ~ \"$\""