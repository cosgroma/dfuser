# Structured Prompt for Telemetry Manager Embedded Software Module

**1. Context Overview:**

- **Module:** Telemetry Manager (TelemetryManager.c)
- **Purpose:**
  - Manages telemetry data acquisition, parsing, and distribution within a GNSS (Global Navigation Satellite System) receiver component.
  - Responsible for processing incoming satellite navigation messages, parsing ephemeris, almanac, and UTC/Ionospheric parameters, and updating shared memory regions for inter-module communication.

**2. Integration Requirements:**

- **Concurrency:**
  - Operates in a dedicated OS thread, triggered by events.
  - Synchronization via spinlocks and events.
- **Inter-Module Communication:**
  - Shared memory channels using `P_IOChannel`.
  - Multicast events for notification of data availability.
- **Constraints:**
  - Real-time response required; thread blocking should be minimized.
  - Memory usage and execution timing must remain predictable.

**3. Module Interface:**

- **Initialization:**
  - `TlmMan_Initialize()`: Initializes telemetry resources, shared memory channels, and events.
- **Core Tasks:**
  - `telem_task`: Event-driven main telemetry parsing and update loop.
- **Key Data Structures:**
  - `TelemetryStats`: Tracks statistics on received satellite frames and parsing outcomes.
  - Shared memory structures (`MetadataGPSLnavEphemeris`, `MetadataGPSIonoUtcParameters`, `MeasurementSatnavSubframe`).

**4. External API Dependencies:**

- **OS/Event Management API:**

  ```c
  P_Event_t p_osCreateEvent(u32 event_id, u32 flags);
  void p_osPendEvent(P_Event_t event);
  void p_osPostEvent(P_Event_t event);
  ```

- **Spinlock API:**
  
  ```c
  P_SpinLock_t p_osCreateSpinLock(u32 type);
  void p_osTakeSpinLock(P_SpinLock_t lock);
  void p_osGiveSpinLock(P_SpinLock_t lock);
  ```

- **Shared Memory API (**``**):**
  
  ```c
  P_IOChannel_t p_iocCreate(const char* name, P_IOChannelOptions_t options);
  int p_iocWrite(P_IOChannel_t channel, const void* buffer, u32 size);
  ```

- **Parsing APIs:**

  ```c
  int ParseFrame_LNAV(const ExtendedSubframeData* data, MetadataGPSLnavEphemeris* ephem);
  int ParseFrame_CNAV(const ExtendedSubframeData* data, MetadataGPSCnavEphemeris* ephem);
  int ParseFrame_INAV(const ExtendedSubframeData* data, MetadataGalileoEphemeris* ephem);
  int ParseUTCASPN(const AlmanacPageData* data, MetadataGPSIonoUtcParameters* utc);
  ```

- **Shared Memory Update APIs:**

  ```c
  void UpdateASPNHeader();
  void UpdateASPNMHeader();
  void UpdateASPNTimestamp();
  ```


**5. Implementation Constraints & Guidelines:**

- **Coding Guidelines:**
  - Follow MISRA guidelines for embedded C code.
  - Minimize dynamic memory allocation.
  - Clear and explicit error handling required.
- **Toolchain:**
  - Compatible with provided platform libraries (`platform/P_*`, `gnss/*`).
- **Testing Requirements:**
  - Unit tests covering telemetry data parsing and shared memory updates.
  - Integration tests verifying event-driven updates.

**6. Desired Deliverable Format:**

- Clean, documented, MISRA-compliant C implementation of the requested functionalities or improvements.
- Explicit error handling and clear separation of concerns in implementation.
- Accompanying unit tests validating correct behavior and robustness.

**Additional Notes:**

- Provide suggestions or code snippets for improving robustness, real-time compliance, or maintainability where applicable.
