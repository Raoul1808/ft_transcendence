#!/bin/bash

GDDIR=/tmp/transcendence-godot-tmp

download_godot() {
    mkdir -p $GDDIR
    pushd $GDDIR
    echo "Downloading godot"
    curl -L https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_linux.x86_64.zip -o godot.zip
    echo "Extracting godot"
    unzip godot.zip
    find . -name "Godot*" -exec mv "{}" "godot" \;
    echo "Downloading godot export templates"
    curl -L https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz -o godot-templates.tpz
    echo "Extracting templates"
    unzip godot-templates.tpz
    echo "Cleaning up"
    rm -f godot.zip godot-templates.tpz
    echo "Godot is ready! At $GDDIR"
    popd
}

if [[ ! -d $GDDIR ]]; then
    download_godot
fi

templates_dir=$HOME/.local/share/godot/export_templates

dir_exists=false

mkdir -p $templates_dir
if [ -d $templates_dir/4.7.2.stable ]; then
    echo "Backing up templates directory"
    mv $templates_dir/4.7.2.stable $templates_dir/4.7.2.stable.bak
    dir_exists=true
fi
echo "Symlinking tmp templates directory"
ln -s $GDDIR/templates $templates_dir/4.7.2.stable
rm -rf game/game-export
mkdir game/game-export
echo "Exporting"
$GDDIR/godot --headless --export-release "index.html" game/project.godot
rm -rf game-export/*
mv game/game-export/* game-export
echo "Removing symlink"
rm -f $templates_dir/4.7.2.stable
if [ $dir_exists = true ]; then
    echo "Restoring templates directory"
    mv $templates_dir/4.7.2.stable.bak $templates_dir/4.7.2.stable
fi
echo "Export done!"

echo "Moving export to frontend directory"

mv game-export/index.html game-export/game.html
mv game-export frontend/public/game-export

echo "All done!"
