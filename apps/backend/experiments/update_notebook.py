#!/usr/bin/env python3
import json

# Read the notebook
with open('agent_pipeline_evaluation.ipynb', 'r') as f:
    nb = json.load(f)

# Find the cell with "Load transcript"
for cell in nb['cells']:
    if cell['cell_type'] == 'code' and cell['source']:
        source = ''.join(cell['source'])
        if 'transcript_file = \'sample_visit_1.txt\'' in source:
            # Replace the content
            new_source = [
                "# Load YOUR recorded audio file\n",
                "audio_file = '7f935bd1-6976-4fc7-b9a3-08aa59211c34.m4a'\n",
                "\n",
                "print(f\"🎙️ Loading your recorded audio: {audio_file}\")\n",
                "transcript = transcribe_audio(audio_file)\n",
                "\n",
                "print(f\"\\n📝 Transcribed {len(transcript)} characters\")\n",
                "print(f\"\\n📄 Transcript preview:\\n{transcript[:300]}...\")\n",
                "\n",
                "# Alternative: Use text transcript instead\n",
                "# transcript_file = 'sample_visit_1.txt'\n",
                "# with open(f'transcripts/{transcript_file}', 'r') as f:\n",
                "#     transcript = f.read()\n",
                "# print(f\"✓ Loaded text transcript ({len(transcript)} chars)\")\n"
            ]
            cell['source'] = new_source
            break

# Write back
with open('agent_pipeline_evaluation.ipynb', 'w') as f:
    json.dump(nb, f, indent=1)

print("✓ Updated notebook to load your audio file!")
