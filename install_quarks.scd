// Install all required Quarks for TidalCycles/SuperDirt
// Run this once to set up all necessary SuperCollider extensions
// Usage: sclang install_quarks.scd

(
"Installing required Quarks for TidalCycles...".postln;

// Check and install Vowel quark (required for vowel filters)
if(Quarks.isInstalled("Vowel").not, {
    "Installing Vowel quark...".postln;
    Quarks.install("Vowel");
    "Vowel installed.".postln;
}, {
    "Vowel already installed.".postln;
});

// Install SuperDirt quark
if(Quarks.isInstalled("SuperDirt").not, {
    "Installing SuperDirt...".postln;
    Quarks.install("SuperDirt");
    "SuperDirt installed.".postln;
}, {
    "SuperDirt already installed.".postln;
});

// Install Dirt-Samples (required sample library)
if(Quarks.isInstalled("Dirt-Samples").not, {
    "Installing Dirt-Samples...".postln;
    Quarks.install("Dirt-Samples");
    "Dirt-Samples installed.".postln;
}, {
    "Dirt-Samples already installed.".postln;
});

"".postln;
"All required Quarks installed!".postln;
"Please restart SuperCollider for changes to take effect.".postln;
"Then run: sclang startup.scd".postln;

// Exit after installation
0.exit;
);
