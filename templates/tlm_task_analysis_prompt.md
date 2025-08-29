# Telemetry Manager Task Analysis

## Objective

We want to do an analysis of the telemetry manager task in the context of the SERGEANT Channel Controller (CC) component. 

The telemetry manager task is responsible for parsing the telemetry data from the tracked GNSS satellites and updating the shared memory with the parsed data. The telemetry manager task is a critical task in the CC as it is responsible for updating the ephemeris and iono-utc data which is used by SM to calculate SV positions and do measurement corrections.

```c
P_THREAD_FUNC_DECLARE(telem_task) {
    (void)arg;

    s32 sv;
    int status;
    int ephem_updated, iono_utc_updated;
    int codeType;

    // int ephem_updated, iono_utc_updated, almanac_updated;

    // create iGNSS_Ephemeris shared memory interface to sm
    P_IOChannelOptions_t gnss_ephem_shm_opt;
    const char *gnss_ephem_shmname = CC_GNSS_EPHEM_UPDATE_SHM_NAME;
    gnss_ephem_shm_opt = p_iocSetShmOptions(MAX_SV + 1, sizeof(EphemerisType));
    tlm_man.gnss_ephem_shm_channel = p_iocCreate(gnss_ephem_shmname, gnss_ephem_shm_opt);
    p_iocDeleteOptions(&gnss_ephem_shm_opt);

    // create GPSLnavUpdate event for sm and other components
    tlm_man.gnss_ephem_event = p_osCreateMultiCastEvent(CC_GNSS_EPHEM_UPDATE_EVENT_NAME, 0);

    // create Iono UTC shared memory interface to sm
    P_IOChannelOptions_t gps_iono_utc_shm_opt;
    const char *gps_iono_utc_shm_name = CC_GPS_IONO_UTC_UPDATE_SHM_NAME;
    gps_iono_utc_shm_opt = p_iocSetShmOptions(1, sizeof(MetadataGPSIonoUtcParameters));
    tlm_man.gps_iono_utc_shm_channel = p_iocCreate(gps_iono_utc_shm_name, gps_iono_utc_shm_opt);
    p_iocDeleteOptions(&gps_iono_utc_shm_opt);

    // create GPS Iono UTC Update event for sm and other components
    tlm_man.gps_iono_utc_event = p_osCreateMultiCastEvent(CC_GPS_IONO_UTC_UPDATE_EVENT_NAME, 0);

    // create Subframe shared memory interface to sm
    P_IOChannelOptions_t gps_subframe_shm_opt;
    const char *gps_subframe_shm_name = CC_GPS_SUBFRAME_UPDATE_SHM_NAME;
    gps_subframe_shm_opt = p_iocSetShmOptions(MAX_SV + 1, sizeof(MeasurementSatnavSubframe));
    tlm_man.gps_subframe_shm_channel = p_iocCreate(gps_subframe_shm_name, gps_subframe_shm_opt);
    p_iocDeleteOptions(&gps_subframe_shm_opt);

    // create GPS SubFrame Update event for sm and other components
    tlm_man.gps_subframe_event = p_osCreateMultiCastEvent(CC_GPS_SUBFRAME_UPDATE_EVENT_NAME, 0);

    memset(&stats, 0, sizeof(TelemetryStats));
    PopulateASPNMHeader(&tlm_man.gps_iono_utc.info);

    for (int sv = 0; sv <= MAX_SV; ++sv) {
        PopulateASPNMHeader(&tlm_man.gnss_ephem.lnav_ephem[sv].info);
    }

    tlm_man.lock = p_osCreateSpinLock(spin_task_only);

    FOREVER {
        p_osPendEvent(telem_event);
        p_osTakeSpinLock(tlm_man.lock);
        status = 0;
        ephem_updated = FALSE;
        iono_utc_updated = FALSE;
        //
        for (sv = 1; sv <= MAX_SV; ++sv) {
            if (tlm_man.subframe_data[sv]
                    .parseEphemeris) {  // todo make a valid and parsed flag, check parsed here and
                                        // set to false afterwards
                // codeType = tlm_man.subframe_data[sv].parseEphemeris;
                // codeType = CTYPE_L1CA; //@todo make this dynamic, and separate from
                // one-dimensional sv indexing to allow for simultaneous multi-constellation
                // operation zhu
                if ((codeType != CTYPE_L1CA) && (codeType != CTYPE_E1B))
                    codeType = CTYPE_L1CA;  // zhu, only have these two tested
                switch (codeType) {
                    case CTYPE_L1CA:
                        tlm_man.gnss_ephem.lnav_ephem[sv].prn = sv;
                        status = ParseFrame_LNAV((ExtendedSubframeData *)&tlm_man.subframe_data[sv],
                                                    &tlm_man.gnss_ephem.lnav_ephem[sv]);
                        stats.ephemeris_parsed[sv]++;
                        if (status >= 0) {
                            manager.svdata[sv].nav_meas.tot.wn =
                                tlm_man.gnss_ephem.lnav_ephem[sv].orbit.wn_t_oe;
                            UpdateASPNMHeader(&tlm_man.gnss_ephem.lnav_ephem[sv].info);
                            UpdateASPNTimestamp(
                                &tlm_man.gnss_ephem.lnav_ephem[sv].time_of_validity);
                            tlm_man.subframe_data[sv].valid[0] = FALSE;
                            tlm_man.subframe_data[sv].valid[1] = FALSE;
                            tlm_man.subframe_data[sv].valid[2] = FALSE;
                            ephem_updated = TRUE;
                        }
                        break;
                    case CTYPE_E1B:
                        tlm_man.gnss_ephem.inav_ephem[sv].prn = sv;
                        status = ParseFrame_INAV((ExtendedSubframeData *)&tlm_man.subframe_data[sv],
                                                    &tlm_man.gnss_ephem.inav_ephem[sv]);
                        if (status >= 0) {
                            manager.svdata[sv].nav_meas.tot.wn =
                                tlm_man.gnss_ephem.inav_ephem[sv].orbit.wn_t_oe;
                            UpdateASPNMHeader(&tlm_man.gnss_ephem.inav_ephem[sv].info);
                            UpdateASPNTimestamp(
                                &tlm_man.gnss_ephem.inav_ephem[sv].time_of_validity);
                            tlm_man.subframe_data[sv].valid[0] = FALSE;
                            tlm_man.subframe_data[sv].valid[1] = FALSE;
                            tlm_man.subframe_data[sv].valid[2] = FALSE;
                            tlm_man.subframe_data[sv].valid[3] = FALSE;
                            tlm_man.subframe_data[sv].valid[4] = FALSE;
                            ephem_updated = TRUE;
                        }
                        break;
                    case CTYPE_L2CM:
                        tlm_man.gnss_ephem.cnav_ephem[sv].prn = sv;
                        status = ParseFrame_CNAV((ExtendedSubframeData *)&tlm_man.subframe_data[sv],
                                                    &tlm_man.gnss_ephem.cnav_ephem[sv]);
                        if (status >= 0) {
                            manager.svdata[sv].nav_meas.tot.wn =
                                tlm_man.gnss_ephem.cnav_ephem[sv].orbit.wn_t_oe;
                            UpdateASPNMHeader(&tlm_man.gnss_ephem.cnav_ephem[sv].info);
                            UpdateASPNTimestamp(
                                &tlm_man.gnss_ephem.cnav_ephem[sv].time_of_validity);
                            tlm_man.subframe_data[sv].valid[0] = FALSE;
                            tlm_man.subframe_data[sv].valid[1] = FALSE;
                            tlm_man.subframe_data[sv].valid[2] = FALSE;
                            ephem_updated = TRUE;
                        }
                        break;
                    default:
                        printf("CC: [WARN] - Don't know decode type\n");
                        break;
                }

                tlm_man.subframe_data[sv].parseEphemeris = 0;
            }
            if (tlm_man.almanac_data[sv].good_page == TRUE) {
                // ParsePage((AlmanacPageData *)&tlm_man.almanac_data[sv], (AlmanacData
                // *)&tlm_man.almanacs[sv]);
                stats.almanacs_parsed[sv]++;
                // tlm_man.almanac_data[sv].good_page = FALSE;
                // almanac_updated = TRUE;
            }
        }

        if (tlm_man.utc_data.good_page == TRUE) {
            ParseUTCASPN(&tlm_man.utc_data, &tlm_man.gps_iono_utc);
            UpdateASPNMHeader(&tlm_man.gps_iono_utc.info);
            UpdateASPNTimestamp(&tlm_man.gps_iono_utc.time_of_validity);
            tlm_man.utc_data.good_page = FALSE;

            iono_utc_updated = TRUE;
        }
        if (tlm_man.health_data[0].good_page == TRUE && tlm_man.health_data[1].good_page == TRUE) {
            ParseHealth(tlm_man.health_data, tlm_man.almanacs);
            // almanac_updated = TRUE;
        }

        if (tlm_man.send_subframe) {
            GNSSSubFrameUpdate();
            tlm_man.send_subframe = FALSE;
        }

        if (ephem_updated) GNSSUpdate(codeType);

        if (iono_utc_updated) GPSIonoUtcUpdate();

        p_osGiveSpinLock(tlm_man.lock);
    }
    P_THREAD_FUNC_RETURN;
}
```