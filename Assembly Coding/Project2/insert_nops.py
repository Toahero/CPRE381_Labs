import re

# Load your RISC-V source from a file
name = input("Enter the file name: ");

with open(name, "r") as f:
    code = f.read()

# Identify instruction lines (exclude labels and comments)
instruction_pattern = re.compile(r'^\s*[a-zA-Z]+\s+[^:]+')
outputName = "Modified_" + name
output_lines = []
for line in code.splitlines():
    stripped = line.strip()
    # Keep labels, directives, and comments intact
    if stripped.endswith(':') or stripped.startswith('.') or stripped.startswith('#') or stripped == '':
        output_lines.append(line)
        continue
    # For each instruction, insert four nops after
    if instruction_pattern.match(line):
        output_lines.append(line)
        output_lines.extend(['\tnop'] * 4)
        output_lines.extend('\t')
    else:
        output_lines.append(line)

# Write modified code to a new file
with open(outputName, "w") as f:
    f.write("\n".join(output_lines))

print("✅ Done! File saved as topsort_with_nops.s")
