req_servnow_opsteam <- function(Source)
  (
    ifelse  (
      Source$Assignment_Group == "ITS-EITO-UNIX" ,
      "UNIX"
      ,
      ifelse  (
        Source$Assignment_Group == "ITS EITO OSG Windows" ,
        "Windows"
        ,
        ifelse  (
          Source$Assignment_Group == "ITS EITO TR Windows" ,
          "Windows"
          ,
          ifelse  (
            Source$Assignment_Group == "ITS EITO Windows" ,
            "Windows"
            ,
            ifelse  (
              Source$Assignment_Group == "ITS-EITO-TR-NETWORK" ,
              "Network"
              ,
              ifelse  (
                Source$Assignment_Group == "ITS-EITO-OSG-NWO" ,
                "Network"
                ,
                ifelse  (
                  Source$Assignment_Group == "ITS-EITO-TR-NETWORK-IT-MANAGER-1" ,
                  "OTHERS"
                  ,
                  ifelse  (
                    Source$Assignment_Group == "ITS-EITO-Data Storage-SAN" ,
                    "Storage and Data Protection"
                    ,
                    ifelse  (
                      Source$Assignment_Group == "ITS-EITO-Data Storage-NAS" ,
                      "Storage and Data Protection"
                      ,
                      ifelse  (
                        Source$Assignment_Group == "ITS-EITO-DATA Protection" ,
                        "Storage and Data Protection"
                        ,
                        ifelse  (
                          Source$Assignment_Group == "ITS-EITO-TR-DCM" ,
                          "Data Centre Mgmt"
                          ,
                          ifelse  (
                            Source$Assignment_Group == "ITS-EITO-TR-NETWORK-PERFORMANCE" ,
                            "Infrastructure Tools & Analysis"
                            ,
                            ifelse  (
                              Source$Assignment_Group == "VEN-IBM-AIX Source" ,
                              "Vendor - AIX"
                              ,
                              ifelse  (
                                Source$Assignment_Group == "ITS-EITO-Database-DB2" ,
                                "Database"
                                ,
                                ifelse  (
                                  Source$Assignment_Group == "ITS-EITO-Database-SQL" ,
                                  "Database"
                                  ,
                                  ifelse  (
                                    Source$Assignment_Group == "ITS-EITO-Database-Oracle" ,
                                    "Database"
                                    ,
                                    ifelse  (
                                      Source$Assignment_Group == "ITS-EITO-Database-Sybase" ,
                                      "Database"
                                      ,
                                      ifelse  (
                                        Source$Assignment_Group == "ITS-EITO-Database-Essbase" ,
                                        "Database"
                                        ,
                                        ifelse  (
                                          Source$Assignment_Group == "ITS-EITO-Database Netezza" ,
                                          "Database"
                                          ,
                                          ifelse  (
                                            Source$Assignment_Group == "ITS-EITO-Database-Exadata" ,
                                            "Database"
                                            ,
                                            ifelse  (
                                              Source$Assignment_Group == "ITS EITO TR Database" ,
                                              "Database"
                                              ,
                                              ifelse  (
                                                Source$Assignment_Group == "ITS-EITO-OSG-MW" ,
                                                "Middleware"
                                                ,
                                                ifelse  (
                                                  Source$Assignment_Group == "ITS-EITO-TR-MW" ,
                                                  "Middleware"
                                                  ,
                                                  ifelse  (
                                                    Source$Assignment_Group == "ITS-EITO-OSG-iOS" ,
                                                    "iSeries"
                                                    ,
                                                    ifelse  (
                                                      Source$Assignment_Group == "ITS-EITO-IOS-APP" ,
                                                      "iSeries"
                                                      ,
                                                      ifelse  (
                                                        Source$Assignment_Group == "ITS-OPS-IOS400" ,
                                                        "iSeries"
                                                        ,
                                                        ifelse  (
                                                          Source$Assignment_Group == "ITS-OPS-DCO-HOST-DOC" ,
                                                          "Host Ops"
                                                          ,
                                                          ifelse  (
                                                            Source$Assignment_Group == "ITS-EITO-OSG-Monitoring" ,
                                                            "Monitoring Tools Optimization"
                                                            ,
                                                            ifelse  (
                                                              Source$Assignment_Group == "ITS-EITO-TR-Monitoring" ,
                                                              "Monitoring Tools Optimization"
                                                              ,
                                                              ifelse  (
                                                                Source$Assignment_Group == "ITS-EITO-CloudOps" ,
                                                                "Cloud",
                                                                "OTHERS"
                                                              )
                                                            )
                                                          )
                                                        )
                                                      )
                                                    )
                                                  )
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
    
  )
# if (Source=="x"){
#   ifelse  (
#     Source$Assignment_Group == "ITS-EITO-UNIX" ,
#     "UNIX"
#     ,
#     ifelse  (
#       Source$Assignment_Group == "ITS EITO OSG Windows" ,
#       "Windows","XXXXXXXXXXXXXXXXXXXXXXXXXx"))}
