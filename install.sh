#!/bin/bash
# Install /make-slides skill for Claude Code
# Usage: bash install.sh

set -e

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
COMMANDS_DIR="$CLAUDE_DIR/commands"

echo "Installing /make-slides skill for Claude Code..."

# Create directories
mkdir -p "$SKILLS_DIR/enhance-slides"
mkdir -p "$SKILLS_DIR/slide-generator/references"
mkdir -p "$COMMANDS_DIR"

# Copy skill files
cp skills/enhance-slides/SKILL.md "$SKILLS_DIR/enhance-slides/SKILL.md"
cp skills/slide-generator/SKILL.md "$SKILLS_DIR/slide-generator/SKILL.md"
cp skills/slide-generator/references/*.md "$SKILLS_DIR/slide-generator/references/"

# Copy command
cp commands/make-slides.md "$COMMANDS_DIR/make-slides.md"

echo ""
echo "Installed successfully!"
echo ""
echo "  Command:  $COMMANDS_DIR/make-slides.md"
echo "  Skills:   $SKILLS_DIR/enhance-slides/SKILL.md"
echo "            $SKILLS_DIR/slide-generator/SKILL.md"
echo ""
echo "Usage: Open Claude Code and type:"
echo "  /make-slides sorting.pptx"
echo "  /make-slides chapter5.pdf"
echo '  /make-slides "Binary Search Trees"'
