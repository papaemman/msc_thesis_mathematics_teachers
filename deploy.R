#################################
#                               #
#   Deploy app in shinyapps.io  #
#                               #
#################################


# Get token from shinyapps.io
rsconnect::setAccountInfo(name='papaemman',
                          token='0665CB4ACC92A946CC33BBC932386933',
                          secret='D/mxo88LiEctFLahESYQxAVNyu6FFPGrEUlxSiaG')


# Deploying apps
# To deploy your application, use the deployApp command from the rsconnect packages.
library(rsconnect)
deployApp()


## Logs (during deployment) ----

# Preparing to deploy application...DONE
# Uploading bundle for application: 3687453...DONE
# Deploying bundle: 4263718 for application: 3687453 ...
# Waiting for task: 877236832
# building: Parsing manifest
# building: Building image: 4871672
# building: Installing system dependencies
# building: Fetching packages
# building: Installing packages
# building: Installing files
# building: Pushing image: 4871672
# deploying: Starting instances
# rollforward: Activating new instances
# success: Stopping old instances
# Application successfully deployed to https://papaemman.shinyapps.io/msc_thesis_mathematics_teachers/
#   Warning messages:
#   1: In utils::tar(bundlePath, files = ".", compression = "gzip", tar = "internal") :
#   storing paths of more than 100 bytes is not portable:
#   ‘./data/Ερωτηματολόγιο Διπλωματικής Εργασίας (Απαντήσεις) (1).xlsx’
# 2: In utils::tar(bundlePath, files = ".", compression = "gzip", tar = "internal") :
#   using GNU extension for long pathname