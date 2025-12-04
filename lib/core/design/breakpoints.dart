enum Breakpoint { xs, sm, md, lg, xl }

Breakpoint resolveBreakpoint(double width, double height) {
  Breakpoint breakpoint;
  if (width < 500) {
    breakpoint = Breakpoint.xs;
  } else if (width < 700) {
    breakpoint = Breakpoint.sm;
  } else if (width < 1280) {
    breakpoint = Breakpoint.md;
  } else if (width < 1920) {
    breakpoint = Breakpoint.lg;
  } else {
    breakpoint = Breakpoint.xl;
  }

  if (height < 500) {
    return Breakpoint.xs;
  }
  if (height < 600) {
    return Breakpoint.sm;
  }
  if (height < 700) {
    return Breakpoint.md;
  }

  return breakpoint;
}
