# Open output file early in write mode
set file_id [open "rmsd_matrix.txt" "w"]

# Get total frames once
set num_frames [molinfo top get numframes]

# Main calculation loop
for {set ref_frame 0} {$ref_frame < $num_frames} {incr ref_frame} {
    # Create reference selection once per outer loop
    set ref_sel [atomselect top "protein" frame $ref_frame]
    
    # Initialize row buffer
    set row_buffer {}
    
    # Inner comparison loop
    for {set fit_frame 0} {$fit_frame < $num_frames} {incr fit_frame} {
        set fit_sel [atomselect top "protein" frame $fit_frame]
        
        # Perform alignment and measurement
        set trans_mat [measure fit $fit_sel $ref_sel]
        $fit_sel move $trans_mat
        set rmsd [measure rmsd $ref_sel $fit_sel]
        
        # Append to row buffer
        lappend row_buffer $rmsd
        
        # Cleanup fit selection immediately
        $fit_sel delete
    }
    
    # Write completed row to disk and clear buffer
    puts $file_id [join $row_buffer "\t"]
    unset row_buffer
    
    # Cleanup reference selection
    $ref_sel delete
    
    # Optional: Add progress reporting
    puts "Processed frame $ref_frame of $num_frames"
    flush stdout
}

close $file_id
