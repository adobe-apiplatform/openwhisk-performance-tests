/**
* This action keeps track of a global variable to count how many times
*  the action is reused accross invocations.

* At the same time the action tracks a `value` parameter, that is useful
*  when testing that a sequece with 5 actions, outputs `value:5` at the end;
*  this indicates that each action in the sequence was invoked.
*
*/
function main(args) {
  return new Promise(
    (resolve,reject) => {
      let timeout = args.timeout || 100;
      let val = args.value ? args.value + 1 : 1;
      global._reused_counter = global._reused_counter || 0;
      console.log("[invoking] ... counter=" + global._reused_counter);
      setTimeout( () => {
        global._reused_counter++;
        console.log("[invoked] ... counter=" + global._reused_counter);
        resolve({
          value: val,
          action_reused_counter: global._reused_counter,
          timeout: timeout
        })
      }, timeout);
    }
  );
}
