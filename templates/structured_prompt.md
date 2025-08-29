
## Structured Prompt Framework for Embedded Software Module Design:

### 1. **Context Overview**
   - **Component Purpose**: Clearly define what the module's responsibility is in the larger embedded system.  
   - **Use Case/Scenario**: Describe at least one representative use case or scenario where the module is expected to function, clarifying operational context.

### 2. **Integration Requirements**
   - **Cohesion Requirements**: Explicitly describe how this module interacts or integrates within the broader component/system.  
     *(For example: communication channels, state handling, timing dependencies, concurrency constraints.)*
   
   - **Constraints**: Clearly specify any embedded-system specific constraints:
     - Memory limitations
     - Timing and performance targets
     - Power consumption constraints
     - Real-time requirements

### 3. **Interface Definition**
   - **Input/Output Interfaces**: Clearly define the expected input/output of the module (e.g., function signatures, data structures, signals).
   - **Behavioral Contract**: Clarify behavioral expectations (e.g., return conditions, error handling policies, event handling).

### 4. **External Library Integration**
   - **Library Overview**: Briefly describe the role/purpose of the external library or subsystem in the design.
   - **API Relevant Subset**: Provide only the relevant subset of the external library’s API necessary for this task, particularly:
     - Function/method signatures (clearly indicated parameters, types, and expected returns)
     - Important constants or macros
     - Relevant data structures
   - **Behavioral Notes**: Include short descriptions or notes on unusual/non-obvious behavior of external API functions (e.g., blocking calls, side effects, concurrency considerations, hardware dependencies).
   
   **How much API to supply?**
   - Only include parts of the external library interface essential to implement the current module accurately.
   - Provide at minimum:
     - Functions directly called by your module.
     - Any callback mechanisms or signals/events your module must respond to.
     - Non-standard patterns or behaviors critical to correctness or integration.

### 5. **Implementation Constraints & Guidelines**
 - Coding standards or style conventions (e.g., MISRA compliance, naming conventions, safety-critical guidelines)
 - Required programming languages/toolchains
 - Testing and validation expectations (e.g., unit tests, hardware-in-loop tests, specific simulation/emulation expectations)
 - Considerations for code clarity, modularity, reusability, and maintainability

### 6. **Desired Deliverable Format**

- Clearly state the expected output format:
  - Complete code module
  - Function implementations only
  - Interface definitions or header files
  - Pseudocode with specific annotations

---

## Example of a concise prompt using this structure:

```markdown
You are developing an embedded C module responsible for sensor data acquisition within a larger vehicle telemetry system. The module will periodically read sensor values via an external non-standard I2C library and report these values to another system component over CAN bus.

Integration requirements:
- Your module must run periodically every 10 ms.
- Adhere to AUTOSAR guidelines.
- The module must remain responsive; blocking calls should not exceed 500 µs.

Module Interface:
- `Sensor_ReadData(SensorData_t* output)`: populates output with sensor values; returns status (success/error).

External library API subset (provided for your implementation):
```c
// Initializes the external sensor hardware, returns 0 on success.
int Sensor_Init(void);

// Reads raw sensor data into provided buffer, returns bytes read or negative error code.
int Sensor_I2C_Read(uint8_t sensorAddr, uint8_t* buffer, uint16_t length);

// Note: Sensor_I2C_Read may block up to 300 µs; returns -EIO on communication failure.
```

Constraints:

- Avoid dynamic memory allocation.
- Provide error handling for communication failures explicitly.

Deliverable:

- Implement `Sensor_ReadData()` adhering strictly to provided constraints.
- Provide relevant unit tests to verify correct behavior.

```

---

**Why this structure works well:**
- **Clarity and Conciseness:** Balances detailed information with brevity.
- **Focused API Exposure:** Prevents confusion and irrelevant implementations.
- **Accurate Implementation:** Minimizes guesswork through clear interface and behavioral contracts.
- **Maintainability:** Ensures cohesiveness within the larger system by emphasizing integration points clearly.