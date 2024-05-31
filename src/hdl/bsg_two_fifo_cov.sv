//
// Eric Yu   05/2024
//
// This module defines functional coverages of module bsg_two_fifo


`include "bsg_defines.sv"

module bsg_two_fifo_cov
  (input clk_i
  ,input reset_i

  // interface signals
  ,input v_i
  ,input yumi_i

  // internal registers
  ,input head_r
  ,input tail_r
  ,input empty_r
  ,input full_r
  );

  // reset
  covergroup cg_reset @(negedge clk_i);
    coverpoint reset_i;
  endgroup

  // Break down covergroup based on the FIFO behaviors

  // empty
  covergroup cg_empty @ (negedge clk_i iff ~reset_i & empty_r & ~full_r);

    cp_v:    coverpoint v_i;
    // cannot deque when empty
    cp_yumi: coverpoint yumi_i {illegal_bins ig = {1};}
    cp_head: coverpoint head_r;
    cp_tail: coverpoint tail_r;

    cross_all: cross cp_v, cp_yumi, cp_head, cp_tail {
      // by definition, fifo empty means that head and tail are at the same location
      illegal_bins ig0 = cross_all with (cp_head != cp_tail);
    }

  endgroup

  // full
  covergroup cg_full @ (negedge clk_i iff ~reset_i & ~empty_r & full_r);

    cp_v:    coverpoint v_i;
    cp_yumi: coverpoint yumi_i;
    cp_head: coverpoint head_r;
    cp_tail: coverpoint tail_r;

    cross_all: cross cp_v, cp_yumi, cp_head, cp_tail {
      // by definition, fifo full means that head and tail are at the same location, similar to empty
      illegal_bins ig0 = cross_all with (cp_head != cp_tail);
    }

  endgroup

  // neither empty nor full / fifo in normal operatiion
  covergroup cg_op @ (negedge clk_i iff ~reset_i & ~empty_r & ~full_r);

    cp_v:    coverpoint v_i;
    cp_yumi: coverpoint yumi_i;
    cp_head: coverpoint head_r;
    cp_tail: coverpoint tail_r;

    cross_all: cross cp_v, cp_yumi, cp_head, cp_tail {
      // by definition, a fifo in normal operation means that head and tail are not at the same location
      illegal_bins ig0 = cross_all with (cp_head == cp_tail);
    }
  endgroup

  // create cover groups
  cg_reset  cov_reset = new;
  cg_empty  cov_empty = new;
  cg_full   cov_full  = new;
  cg_op     cov_op    = new;

  // print coverages when simulation is done
  final
  begin
    $display("");
    $display("Instance: %m");
    $display("------------------------- Functional Coverage Results -------------------------");
    $display("Reset            functional coverage is %f%%", cov_reset.get_coverage());
    $display("Fifo empty       functional coverage is %f%%", cov_empty.cross_all.get_coverage());
    $display("Fifo full        functional coverage is %f%%", cov_full.cross_all.get_coverage());
    $display("Fifo operational functional coverage is %f%%", cov_op.cross_all.get_coverage());
    $display("-------------------------------------------------------------------------------");
    $display("");
  end

endmodule
