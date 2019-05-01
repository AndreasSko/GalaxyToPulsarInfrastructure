cd /mnt/pulsar
. venv/bin/activate
pulsar -m uwsgi -c config/ --daemonize /mnt/pulsar/uwsgi.log
