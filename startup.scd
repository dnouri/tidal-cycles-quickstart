// SuperCollider startup file for TidalCycles
// Run this each time you want to use TidalCycles

(
// Configure server options BEFORE booting
s.options.numBuffers = 1024 * 64; // Increase buffer count to 64K (default is 1024)
s.options.memSize = 8192 * 32; // Increase memory to 256MB (default is 8192KB)
s.options.maxNodes = 1024 * 32; // Increase max nodes
s.options.numOutputBusChannels = 2; // Stereo output
s.options.numInputBusChannels = 2; // Stereo input
s.options.sampleRate = 48000; // Force 48kHz sample rate

s.waitForBoot {
    ~dirt = SuperDirt(2, s); // two output channels
    
    // Load only essential samples to avoid buffer overflow
    // You can specify custom paths or limit the samples loaded
    ~dirt.loadSoundFiles(
        // Specify paths - if nil, loads from default Dirt-Samples
        paths: nil, 
        // Set to false to avoid re-loading if already loaded
        appendToExisting: false
    );
    
    s.sync; // wait for samples to load
    
    ~dirt.start(57120, 0 ! 12); // start listening on port 57120, create 12 orbits
    
    "SuperDirt is ready!".postln;
    "Number of sample banks loaded: %".format(~dirt.soundLibrary.buffers.size).postln;
    
    // Optional: Show memory usage
    "Server memory usage: % MB".format(s.peakCPU).postln;
    
    // Optional: Record output
    // s.record;
};

s.latency = 0.3; // increase if you get "late" messages
);
