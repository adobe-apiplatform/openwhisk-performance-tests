function main(args) {
  return new Promise(
    (resolve,reject) => {
      let timeout = args.timeout || 100;
      let val = args.value ? args.value + 1 : 1;
      setTimeout(resolve({
        value: val,
        timeout: timeout
      }), timeout);
    }
  );
};
