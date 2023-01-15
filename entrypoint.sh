#!/bin/bash
set -e

rm -f /app-for-try-rails/tmp/pids/server.pid

exec "$@"
