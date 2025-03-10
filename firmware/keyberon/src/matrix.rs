//! Hardware pin switch matrix handling.

use embedded_hal::blocking::delay::DelayUs;
use embedded_hal::digital::v2::{InputPin, OutputPin};

/// Describes the hardware-level matrix of switches.
///
/// Generic parameters are in order: The type of column pins,
/// the type of row pins, the number of columns and rows.
/// **NOTE:** In order to be able to put different pin structs
/// in an array they have to be downgraded (stripped of their
/// numbers etc.). Most HAL-s have a method of downgrading pins
/// to a common (erased) struct. (for example see
/// [stm32f0xx_hal::gpio::PA0::downgrade](https://docs.rs/stm32f0xx-hal/0.17.1/stm32f0xx_hal/gpio/gpioa/struct.PA0.html#method.downgrade))
///
/// TIM5 is used to provide a delay during the matrix scanning.
pub struct Matrix<C, R, const CS: usize, const RS: usize, D>
where
    C: InputPin,
    R: OutputPin,
    D: DelayUs<u32>,
{
    cols: [C; CS],
    rows: [R; RS],
    delay: D,
    select_delay_us: u32,
    unselect_delay_us: u32,
}

impl<C, R, const CS: usize, const RS: usize, D> Matrix<C, R, CS, RS, D>
where
    C: InputPin,
    R: OutputPin,
    D: DelayUs<u32>,
{
    /// Creates a new Matrix.
    ///
    /// Assumes columns are pull-up inputs,
    /// and rows are output pins which are set high when not being scanned.
    pub fn new<E>(
        cols: [C; CS],
        rows: [R; RS],
        delay: D,
        select_delay_us: u32,
        unselect_delay_us: u32,
    ) -> Result<Self, E>
    where
        C: InputPin<Error = E>,
        R: OutputPin<Error = E>,
    {
        let mut res = Self {
            cols,
            rows,
            delay,
            select_delay_us,
            unselect_delay_us,
        };
        res.clear()?;
        Ok(res)
    }
    fn clear<E>(&mut self) -> Result<(), E>
    where
        C: InputPin<Error = E>,
        R: OutputPin<Error = E>,
    {
        for r in self.rows.iter_mut() {
            r.set_high()?;
        }
        Ok(())
    }
}

impl<C, R, const CS: usize, const RS: usize, D, E> crate::input::MatrixScanner<CS, RS, E>
    for Matrix<C, R, CS, RS, D>
where
    C: InputPin<Error = E>,
    R: OutputPin<Error = E>,
    D: DelayUs<u32>,
{
    /// Scans the matrix and checks which keys are pressed.
    ///
    /// Every row pin in order is pulled low, and then each column
    /// pin is tested; if it's low, the key is marked as pressed.
    ///
    /// Delays for a bit after setting each pin, and after clearing
    /// each pin.
    fn get(&mut self) -> Result<[[bool; CS]; RS], E> {
        let mut keys = [[false; CS]; RS];

        for (ri, row) in self.rows.iter_mut().enumerate() {
            row.set_low()?;
            // Delay after setting the pin low.
            // Using a timer for this is probably overkill.
            self.delay.delay_us(self.select_delay_us);
            for (ci, col) in self.cols.iter().enumerate() {
                if col.is_low()? {
                    keys[ri][ci] = true;
                }
            }
            row.set_high()?;
            // Delay after setting the pin high.
            // Using a timer for this is probably overkill.
            self.delay.delay_us(self.unselect_delay_us);
        }
        Ok(keys)
    }
}
