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
    popd
}

if [[ ! -d $GDDIR ]]; then
    download_godot
fi

templates_dir=$HOME/.local/share/godot/export_templates

dir_exists=false

mkdir -p $templates_dir
if [ -d $templates_dir/4.7.2.stable ]; then
    mv $templates_dir/4.7.2.stable $templates_dir/4.7.2.stable.bak
    dir_exists=true
fi
ln -s $GDDIR/templates $templates_dir/4.7.2.stable
mkdir game/game-export
$GDDIR/godot --headless --export-release "index.html" game/project.godot
mv game/game-export game-export
rm -f $templates_dir/4.7.2.stable
if [ $dir_exists = true ]; then
    mv $templates_dir/4.7.2.stable.bak $templates_dir/4.7.2.stable
fi
