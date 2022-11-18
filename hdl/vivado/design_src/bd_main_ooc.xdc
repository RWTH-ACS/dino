################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name user_si570_sysclk_clk_p -period 3.333 [get_ports user_si570_sysclk_clk_p]
create_clock -name GT_DIFF_REFCLK1_0_clk_p -period 4 [get_ports GT_DIFF_REFCLK1_0_clk_p]

################################################################################