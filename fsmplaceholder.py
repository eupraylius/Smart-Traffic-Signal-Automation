def simple_fsm(input_sequence):
    state = "START"  # Initial state
    output = []

    for char in input_sequence:
        if state == "START":
            if char == 'a':
                state = "STATE_A"
            else:
                state = "ERROR"
        elif state == "STATE_A":
            if char == 'b':
                state = "STATE_B"
            else:
                state = "ERROR"
        elif state == "STATE_B":
            if char == 'c':
                state = "END"
            else:
                state = "ERROR"
        elif state == "END":
            # No further transitions from END state
            pass
        elif state == "ERROR":
            # Stay in error state
            pass
        output.append(state)
    return state, output

# Example usage
final_state, state_history = simple_fsm("abc")
print(f"Final state: {final_state}")
print(f"State history: {state_history}")

final_state, state_history = simple_fsm("abx")
print(f"Final state: {final_state}")
print(f"State history: {state_history}")
