req_rms_opsteam <- function(Source)
  (ifelse  (
    RMS$Assignment_Group == "TDI-AS400 Response Team" ,
    "iSeries"
    ,
    ifelse  (
      RMS$Assignment_Group == "TDI-BATCH-Operation Response Team" ,
      "Scheduling Services"
      ,
      ifelse  (
        RMS$Assignment_Group == "TDI-CCI-OPS" ,
        "GSS"
        ,
        ifelse  (
          RMS$Assignment_Group == "TDI-DBA-Oracle access support" ,
          "Database"
          ,
          ifelse  (
            RMS$Assignment_Group == "TDI-ServiceDesk Insurance support" ,
            "GSS"
            ,
            ifelse  (
              RMS$Assignment_Group == "TDI-ServiceDesk Seniors" ,
              "GSS"
              ,
              ifelse  (
                RMS$Assignment_Group == "TDI-ServiceDesk Telepresence" ,
                "GSS"
                ,
                ifelse  (
                  RMS$Assignment_Group == "TDI-Voice Support" ,
                  "GSS"
                  ,
                  ifelse  (
                    RMS$Assignment_Group == "TDI-Unix Response Team" ,
                    "UNIX"
                    ,
                    ifelse  (
                      RMS$Assignment_Group == "TDI-Windows-Response Team" ,
                      "Windows",
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
  ))