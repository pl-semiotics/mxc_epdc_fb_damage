#include <linux/mxcfb.h>

struct mxcfb_damage_update {
  int overflow_notify;
  struct mxcfb_update_data data;
};
