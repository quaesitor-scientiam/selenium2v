module remote

struct FedCM {
	driver RemoteWebDriver
}

fn FedCM.init(driver RemoteWebDriver) FedCM {
	return FedCM{
		driver: driver
	}
}
