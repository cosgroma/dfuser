
# | Legacy Source | New Component |
# | --- | --- |
# | ./core/apps/sdr/src/channel/channel.c | ./comp/cc/src/Channel/Channel.c |
# | ./core/apps/sdr/src/channel/channel.h | ./comp/cc/src/Channel/Channel.h |
# | ./core/apps/sdr/src/controller/controller.c |  |
# | ./core/apps/sdr/src/controller/controller.h |  |
# | ./core/apps/sdr/src/controller/visualization.c |  |
# | ./core/apps/sdr/src/filter/discriminators.c | ./SignalProcessor/filter/discriminators.c |
# | ./core/apps/sdr/src/filter/discriminators.h | ./SignalProcessor/filter/discriminators.h |
# | ./core/apps/sdr/src/filter/loopFilter.c | ./SignalProcessor/filter/loopFilter.c |
# | ./core/apps/sdr/src/filter/loopFilter.h | ./SignalProcessor/filter/loopFilter.h |
# | ./core/daemons/napal/include/napal/correlator.h | ./comp/cc/src/SpreadingCodeManager/napal/correlator.h |
# | ./core/daemons/napal/include/napal/napal.h | ./comp/cc/src/SpreadingCodeManager/napal/napal.h |
# | ./core/daemons/napal/include/napal/resource_manager.h | ./comp/cc/src/SpreadingCodeManager/napal/resource_manager.h |
# | ./core/daemons/napal/include/napal/sages.h | ./comp/cc/src/SpreadingCodeManager/napal/sages.h |
# | ./core/daemons/napal/src/sages/napal.c | ./comp/cc/src/SpreadingCodeManager/napal/napal.c |
# | ./core/daemons/napal/src/sages/resource_manager.c | ./comp/cc/src/SpreadingCodeManager/napal/resource_manager.c |
# | ./core/daemons/napal/src/sages/sages.c | ./comp/cc/src/SpreadingCodeManager/napal/sages.c |
# | ./core/daemons/napal/src/sages/sages_utils.c | ./comp/cc/src/SpreadingCodeManager/napal/sages_utils.c |
# | ./core/apps/sdr/src/smach/sf_clt.c |  ./comp/cc/src/SignalProcessor/smach/sf_clt.c |
# | ./core/apps/sdr/src/smach/sf_core.c |  ./comp/cc/src/SignalProcessor/smach/sf_core.c |
# | ./core/apps/sdr/src/smach/sf_galileo.c |  ./comp/cc/src/SignalProcessor/smach/sf_galileo.c |
# | ./core/apps/sdr/src/smach/sf_mcode.c |  ./comp/cc/src/SignalProcessor/smach/sf_mcode.c |
# | ./core/apps/sdr/src/smach/sf_olt.c |  ./comp/cc/src/SignalProcessor/smach/sf_olt.c |
# | ./core/apps/sdr/src/smach/sf_pcode.c |  ./comp/cc/src/SignalProcessor/smach/sf_pcode.c |
# | ./core/apps/sdr/src/smach/state_array.c |  ./comp/cc/src/SignalProcessor/smach/state_array.c |
# | ./core/apps/sdr/src/smach/state_functions.h |  ./comp/cc/src/SignalProcessor/smach/state_functions.h |
# | ./core/apps/sdr/src/smach/state_types.h |  ./comp/cc/src/SignalProcessor/smach/state_types.h |
# | ./core/apps/sdr/src/smach/state_utils.c |  ./comp/cc/src/SignalProcessor/smach/state_utils.c |
# | ./core/engines/gencor/src/packetizedIO.c | ./comp/cc/src/GEnCor/pktio/packetizedIO.c |
# | ./core/engines/gencor/src/packetizedIO_CA.c | ./comp/cc/src/GEnCor/pktio/packetizedIO_CA.c |
# | ./core/engines/gencor/src/packetizedIO_GalE.c | ./comp/cc/src/GEnCor/pktio/packetizedIO_GalE.c |
# | ./core/engines/gencor/src/packetizedIO_M.c | ./comp/cc/src/GEnCor/pktio/packetizedIO_M.c |
# | | ./comp/cc/src/GEnCor/pktio/packetizedIO_Mem.c |
# | ./core/engines/gencor/src/packetizedIO_P.c | ./comp/cc/src/GEnCor/pktio/packetizedIO_P.c |

# create mapping array for legacy source files
declare -a legacySource=(
    "./core/apps/sdr/src/channel/channel.c"
    "./core/apps/sdr/src/channel/channel.h"
    "./core/apps/sdr/src/controller/controller.c"
    "./core/apps/sdr/src/controller/controller.h"
    "./core/apps/sdr/src/controller/visualization.c"
    "./core/apps/sdr/src/filter/discriminators.c"
    "./core/apps/sdr/src/filter/discriminators.h"
    "./core/apps/sdr/src/filter/loopFilter.c"
    "./core/apps/sdr/src/filter/loopFilter.h"
    "./core/daemons/napal/include/napal/correlator.h"
    "./core/daemons/napal/include/napal/napal.h"
    "./core/daemons/napal/include/napal/resource_manager.h"
    "./core/daemons/napal/include/napal/sages.h"
    "./core/daemons/napal/src/sages/napal.c"
    "./core/daemons/napal/src/sages/resource_manager.c"
    "./core/daemons/napal/src/sages/sages.c"
    "./core/daemons/napal/src/sages/sages_utils.c"
    "./core/apps/sdr/src/smach/sf_clt.c"
    "./core/apps/sdr/src/smach/sf_core.c"
    "./core/apps/sdr/src/smach/sf_galileo.c"
    "./core/apps/sdr/src/smach/sf_mcode.c"
    "./core/apps/sdr/src/smach/sf_olt.c"
    "./core/apps/sdr/src/smach/sf_pcode.c"
    "./core/apps/sdr/src/smach/state_array.c"
    "./core/apps/sdr/src/smach/state_functions.h"
    "./core/apps/sdr/src/smach/state_types.h"
    "./core/apps/sdr/src/smach/state_utils.c"
    "./core/engines/gencor/src/packetizedIO.c"
    "./core/engines/gencor/src/packetizedIO_CA.c"
    "./core/engines/gencor/src/packetizedIO_GalE.c"
    "./core/engines/gencor/src/packetizedIO_M.c"
    "./core/engines/gencor/src/packetizedIO_P.c"
)

# create mapping array for new component files
declare -a newComponent=(
    "./comp/cc/src/Channel/Channel.c"
    "./comp/cc/src/Channel/Channel.h"
    ""
    ""
    ""
    "./SignalProcessor/filter/discriminators.c"
    "./SignalProcessor/filter/discriminators.h"
    "./SignalProcessor/filter/loopFilter.c"
    "./SignalProcessor/filter/loopFilter.h"
    "./comp/cc/src/SpreadingCodeManager/napal/correlator.h"
    "./comp/cc/src/SpreadingCodeManager/napal/napal.h"
    "./comp/cc/src/SpreadingCodeManager/napal/resource_manager.h"
    "./comp/cc/src/SpreadingCodeManager/napal/sages.h"
    "./comp/cc/src/SpreadingCodeManager/napal/napal.c"
    "./comp/cc/src/SpreadingCodeManager/napal/resource_manager.c"
    "./comp/cc/src/SpreadingCodeManager/napal/sages.c"
    "./comp/cc/src/SpreadingCodeManager/napal/sages_utils.c"
    "./comp/cc/src/SignalProcessor/smach/sf_clt.c"
    "./comp/cc/src/SignalProcessor/smach/sf_core.c"
    "./comp/cc/src/SignalProcessor/smach/sf_galileo.c"
    "./comp/cc/src/SignalProcessor/smach/sf_mcode.c"
    "./comp/cc/src/SignalProcessor/smach/sf_olt.c"
    "./comp/cc/src/SignalProcessor/smach/sf_pcode.c"
    "./comp/cc/src/SignalProcessor/smach/state_array.c"
    "./comp/cc/src/SignalProcessor/smach/state_functions.h"
    "./comp/cc/src/SignalProcessor/smach/state_types.h"
    "./comp/cc/src/SignalProcessor/smach/state_utils.c"
    "./comp/cc/src/GEnCor/pktio/packetizedIO.c"
    "./comp/cc/src/GEnCor/pktio/packetizedIO_CA.c"
    "./comp/cc/src/GEnCor/pktio/packetizedIO_GalE.c"
    "./comp/cc/src/GEnCor/pktio/packetizedIO_M.c"
    "./comp/cc/src/GEnCor/pktio/packetizedIO_Mem.c"
    "./comp/cc/src/GEnCor/pktio/packetizedIO_P.c"
)

# create relation array for legacy source files to new component files

# compare two commits in git
# git diff --name-only <commit1> <commit2>

git diff 1653297 cb3dc0f

# git submodule foreach command to show commit history of each submodule

git submodule foreach "echo \#\# $sm_path; git l | head -4" > $DESIGN_DIR/submodule_log.md