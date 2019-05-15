## Place local configuration variables used by the LWR and run.sh in here. For example

## If using the drmaa queue manager, you will need to set the DRMAA_LIBRARY_PATH variable,
## you may also need to update LD_LIBRARY_PATH for underlying library as well.
export DRMAA_LIBRARY_PATH=/usr/lib64/condor/libdrmaa.so

## If you wish to use a variety of Galaxy tools that depend on galaxy.eggs being defined,
## set GALAXY_HOME to point to a copy of Galaxy.
# export GALAXY_HOME=/opt/pulsar/dependencies/galaxy
#
# # https://github.com/galaxyproject/pulsar/issues/134
# export PYTHONPATH=${PYTHONPATH}:/opt/pulsar/dependencies/galaxy/lib
# export GALAXY_LIB=/opt/pulsar/dependencies/galaxy/lib
#
# ## Uncomment to verify GALAXY_HOME is set properly before starting the LWR.
# export TEST_GALAXY_LIBS=1

## If using a manager that runs jobs as real users, be sure to load your Python
## environement in here as well.
#. .venv/bin/activate
