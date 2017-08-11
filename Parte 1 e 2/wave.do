view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 500ps sim:/MemoryBlock/clock 
wave modify -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps Edit:/MemoryBlock/clock 
wave create -driver freeze -pattern counter -startvalue 0 -endvalue 3 -type Range -direction Up -period 50ps -step 1 -repeat forever -starttime 0ps -endtime 1000ps sim:/MemoryBlock/wren 
wave create -driver freeze -pattern counter -startvalue 00000 -endvalue 00100 -type Range -direction Up -period 4ps -step 1 -repeat forever -range 4 0 -starttime 0ps -endtime 1000ps sim:/MemoryBlock/address 
WaveExpandAll -1
wave modify -driver freeze -pattern counter -startvalue 00000 -endvalue 00100 -type Range -direction Up -period 250ps -step 1 -repeat forever -range 4 0 -starttime 0ps -endtime 1000ps Edit:/MemoryBlock/address 
WaveCollapseAll -1
wave clipboard restore
