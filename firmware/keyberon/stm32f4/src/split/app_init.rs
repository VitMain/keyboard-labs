use stm32f4xx_hal::gpio::gpiob;
use stm32f4xx_hal::serial::config::Config;
use stm32f4xx_hal::serial::Listen;
use stm32f4xx_hal::time::U32Ext;
use stm32f4xx_hal::{pac, serial};

pub fn init_serial(
    clocks: &stm32f4xx_hal::rcc::Clocks,
    pb6: gpiob::PB6,
    pb7: gpiob::PB7,
    usart1: pac::USART1,
) -> (
    serial::Tx<stm32f4xx_hal::pac::USART1>,
    serial::Rx<stm32f4xx_hal::pac::USART1>,
) {
    let pins = (pb6.into_alternate(), pb7.into_alternate());
    let mut serial = serial::Serial::new(
        usart1,
        pins,
        Config::default().baudrate(9_600.bps()),
        &clocks,
    )
    .unwrap();
    serial.listen(serial::Event::Rxne);
    serial.split()
}