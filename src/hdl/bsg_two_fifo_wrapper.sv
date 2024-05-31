// TODO: currently this module copies the covergroups from bsg_fifo_1r1w_small_hardened_wrapper. 
// Need to define all the other covergroups for bsg_two_fifo
module bsg_two_fifo_wrapper #(parameter width_p = 16
                            , parameter verbose_p = 0
                            , parameter allow_enq_deq_on_full_p = 0
                            , parameter ready_THEN_valid_p=allow_enq_deq_on_full_p
                            )
   (input clk_i
    , input reset_i

    // input side
    , output              ready_param_o // early
    , input [width_p-1:0] data_i  // late
    , input               v_i     // late

    // output side
    , output              v_o     // early
    , output[width_p-1:0] data_o  // early
    , input               yumi_i  // late
    );

    // Instantiate DUT
    bsg_two_fifo #(.width_p(width_p)
                                  ,.verbose_p(verbose_p)
                                  ,.allow_enq_deq_on_full_p(allow_enq_deq_on_full_p)
                                  ,.ready_THEN_valid_p(ready_THEN_valid_p)
                                  ) fifo
    (.*);

    // Bind Covergroups
    bind bsg_two_fifo bsg_two_fifo_cov
    pc_cov
    (.*
    );

    // Dump Waveforms, comment out if is not running using VCS
    initial begin
        $fsdbDumpvars;
    end

endmodule
