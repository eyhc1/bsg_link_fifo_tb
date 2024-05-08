//
// Eric Yu   05/2024
//
// This module defines functional coverages of module bsg_two_fifo
//
//
// TODO: currently this module copies the covergroups from bsg_fifo_1r1w_small_hardened_cov. 
// Need to define all the other covergroups for bsg_two_fifo

`include "bsg_defines.sv"

module bsg_two_fifo_cov
// TODO: in the example, there's a ,localparam ptr_width_lp = `BSG_SAFE_CLOG2(els_p). dunno what is it and if we need similar thing
//  #(parameter width_p = 16
//   )

  (input clk_i
  ,input reset_i

  // interface signals
  ,input v_i
  ,input yumi_i

  // internal registers
  ,input head_r   // registered in sub-module bsg_mem_1r1w
  ,input tail_r   // registered in sub-module bsg_mem_1r1w
  ,input empty_r  // registered in sub-module bsg_mem_1r1w
  ,input full_r
  );

  // reset
  covergroup cg_reset @(negedge clk_i);
    coverpoint reset_i;
  endgroup

  // Partitioning covergroup into smaller ones
//   // empty
//   covergroup cg_empty @ (negedge clk_i iff ~reset_i & empty & ~full);

//     cp_v: coverpoint v_i;
//     // cannot deque when empty
//     cp_yumi: coverpoint yumi_i {illegal_bins ig = {1};}
//     cp_rptr: coverpoint rptr_r;
//     cp_wptr: coverpoint wptr_r;
//     // If read write same address happened in previous cycle, fifo should
//     // have one element in current cycle, which contradicts with the
//     // condition that fifo is empty.
//     cp_rwsa: coverpoint read_write_same_addr_r {illegal_bins ig = {1};}

//     cross_all: cross cp_v, cp_yumi, cp_rptr, cp_wptr, cp_rwsa {
//       // by definition, fifo empty means r/w pointers are the same
//       illegal_bins ig0 = cross_all with (cp_rptr != cp_wptr);
//     }

//   endgroup

//   // full
//   covergroup cg_full @ (negedge clk_i iff ~reset_i & ~empty & full);

//     cp_v: coverpoint v_i;
//     cp_yumi: coverpoint yumi_i;
//     cp_rptr: coverpoint rptr_r;
//     cp_wptr: coverpoint wptr_r;
//     // If read write same address happened in previous cycle, fifo should
//     // only have one element in current cycle, which contradicts with the
//     // condition that fifo is full.
//     cp_rwsa: coverpoint read_write_same_addr_r {illegal_bins ig = {1};}

//     cross_all: cross cp_v, cp_yumi, cp_rptr, cp_wptr, cp_rwsa {
//       // by definition, fifo full means r/w pointers are the same
//       illegal_bins ig0 = cross_all with (cp_rptr != cp_wptr);
//     }

//   endgroup

//   // fifo normal
//   covergroup cg_normal @ (negedge clk_i iff ~reset_i & ~empty & ~full);

//     cp_v: coverpoint v_i;
//     cp_yumi: coverpoint yumi_i;
//     cp_rptr: coverpoint rptr_r;
//     cp_wptr: coverpoint wptr_r;
//     cp_rwsa: coverpoint read_write_same_addr_r;

//     cross_all: cross cp_v, cp_yumi, cp_rptr, cp_wptr, cp_rwsa {
//       // by definition, r/w pointers are different when fifo is non-empty & non-full
//       illegal_bins ig0 = cross_all with (cp_rptr == cp_wptr);
//       // If read write same address happened in previous cycle, fifo should
//       // only have one element in current cycle. Write-pointer should be
//       // read-pointer plus one (or wrapped-around).
//       illegal_bins ig1 = cross_all with (
//         (cp_rwsa == 1)
//         && (cp_wptr - cp_rptr != 1)
//         && (cp_wptr - cp_rptr != 1-els_p)
//         );
//     }

//   endgroup

  // fifo impossible (fifo cannot be both empty and full at the same time)
  // covergroup cg_impossible @ (negedge clk_i iff ~reset_i & empty & full);

  // create cover groups
  cg_reset cov_reset = new;
//   cg_empty cov_empty = new;
//   cg_full cov_full = new;
//   cg_normal cov_normal = new;

  // print coverages when simulation is done
  final
  begin
    $display("");
    $display("Instance: %m");
    $display("---------------------- Functional Coverage Results ----------------------");
    $display("Reset       functional coverage is %f%%", cov_reset.get_coverage());
    // $display("Fifo empty  functional coverage is %f%%", cov_empty.cross_all.get_coverage());
    // $display("Fifo full   functional coverage is %f%%", cov_full.cross_all.get_coverage());
    // $display("Fifo normal functional coverage is %f%%", cov_normal.cross_all.get_coverage());
    $display("-------------------------------------------------------------------------");
    $display("");
  end

endmodule
